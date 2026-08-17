# 仓库加密架构

> **读者**：用户、AI agent。快速理解本仓库两套加密系统的设计原理与数据流。
> 操作指南见 `new-machine-setup.md`（新机器部署）和 `change-secrets.md`（轮换密钥）。

---

## 为什么需要加密

本仓库包含两类敏感数据：

| 类型 | 示例 | 风险 |
|------|------|------|
| **Secret** | API key、token、对称密钥 | 泄露 = 账户被盗用 |
| **私有配置** | SSH 公网 IP、内部主机名 | 泄露 = 暴露基础设施拓扑 |

它们必须版本控制（多机同步），但不能明文存入 git。本仓库用两套加密系统分别解决。

---

## 两套系统，各管一类

```
┌─────────────────────────────────────────────────────────┐
│  agenix（非对称加密）                                      │
│  管：API key、token 等 short secret                       │
│  文件：secrets/*.age                                      │
│  加密方式：age + SSH ed25519 公钥                          │
│  解密方式：本机 SSH 私钥（非交互，构建时自动）                │
│  存储：密文入库 → 安全 push → 构建时解密到 /run/agenix/     │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│  git-crypt（对称加密）                                     │
│  管：private.nix 等配置文件（内容多、结构化）                 │
│  文件：vars/private.nix（通过 .gitattributes 标记）        │
│  加密方式：AES-256 + 对称 key                              │
│  解密方式：git-crypt unlock <keyfile>                      │
│  存储：工作区透明加解密，git 里存密文，本地看明文             │
└─────────────────────────────────────────────────────────┘
```

---

## 数据流全景

### 写入流程（加密）

```
  用户 / agent
       │
       ▼
┌──────────────┐    ┌──────────────────┐
│  API key 明文 │    │ private.nix 明文  │
└──────┬───────┘    └────────┬─────────┘
       │                     │
       ▼                     ▼
  age -e -r <公钥>      git commit
       │                (git-crypt 透明加密)
       ▼                     │
  secrets/*.age ──────► git push ──────► GitHub
```

### 读取流程（解密）

```
  git pull
       │
       ├──► secrets/*.age（密文，仍不可读）
       │         │
       │         ▼
       │    NixOS 构建时 agenix 解密
       │    (用本机 SSH 私钥)
       │         │
       │         ▼
       │    /run/agenix/<name>  ← pi 等程序读这里
       │
       └──► vars/private.nix（工作区已是明文）
                    │
                    ▼
              Nix 求值直接读取
```

---

## agenix 详解（非对称加密）

### 原理

基于 [age](https://github.com/FiloSottile/age) 加密工具，用 SSH ed25519 公钥作为接收者：

```
加密：age -e -r "ssh-ed25519 AAAA..." -o file.age
解密：age -d -i ~/.ssh/id_ed25519 -o file.txt
```

- **公钥**：多台机器的公钥都可以作为接收者（`vars/public.nix` 里的 `publicKeys`）
- **私钥**：每台机器的 `~/.ssh/id_ed25519`，构建时由 NixOS 激活脚本自动调用解密
- **安全模型**：任何持有对应私钥的机器都能解密，不需要共享密钥

### 文件布局

```
secrets/
├── secrets.nix              # 注册表：每个 .age 允许哪些公钥解密
├── deepseek-api-key.age     # DeepSeek API key（密文）
├── mimo-api-key.age         # MiMo API key（密文）
└── git-crypt-key.age        # git-crypt 对称密钥的备份（密文）
```

### 解密时机

| 平台 | 解密路径 | 触发时机 |
|------|----------|----------|
| NixOS | `/run/agenix/<name>` | `nixos-rebuild switch` 激活时 |
| macOS | `/run/agenix/<name>` | `darwin-rebuild switch` 激活时（重启后需重新 switch） |
| Remote | `${XDG_RUNTIME_DIR}/agenix/<name>` | home-manager switch 激活时 |

### 如何消费

```nix
# pi-coding-agent.nix
apiKey = "!cat /run/agenix/mimo-api-key";
#         ↑ pi 的 "!command" 语法，请求时执行 shell 命令读取密文
```

### 两个正交维度

| 维度 | 操作 | 影响 |
|------|------|------|
| **换内容**（轮换 key） | `agenix -e secrets/<name>.age` | 接收者不变，只改明文 |
| **换接收者**（加/删机器） | 改 `vars/public.nix` → `agenix -r` | 内容不变，重新加密给新列表 |

---

## git-crypt 详解（对称加密）

### 原理

基于 [git-crypt](https://github.com/AGWA/git-crypt)，使用 AES-256 对称加密：

- `.gitattributes` 声明哪些文件需要加密
- `git add/commit` 时自动加密，`git checkout` 时自动解密
- 工作区看到的是明文，git 仓库里存的是密文

### 文件布局

```
.gitattributes          # 声明：vars/private.nix filter=git-crypt diff=git-crypt
vars/
├── public.nix          # 公开变量（明文入库）
└── private.nix         # 私有变量（git-crypt 加密入库）
```

### 解锁流程

```
git clone（密文）──► git-crypt unlock <keyfile> ──► 工作区变明文
                         │
                         │ keyfile 从哪来？
                         │
                         ▼
                    secrets/git-crypt-key.age
                    (由 agenix 加密保护)
```

### 关键特性

- **透明性**：解锁后，`git add`/`git commit`/`git diff` 操作的是明文，加密由 git-crypt hook 自动完成
- **不可逆**：没有 keyfile 就无法解密，即使能 SSH 到机器也不行
- **持久性**：`unlock` 一次后，后续 `git pull` 自动维持解密状态（直到执行 `git-crypt lock`）

---

## 两套系统的协作

git-crypt 的密钥本身也是一个 secret，由 agenix 保护：

```
                    agenix（非对称）
                    ┌─────────────────────┐
                    │ secrets/            │
                    │  ├── *.age (密文)   │
                    │  └── git-crypt-key  │◄──── git-crypt 对称密钥
                    │      .age           │      （也是密文）
                    └─────────────────────┘
                           │
                    构建时解密到
                           │
                           ▼
                    /run/agenix/git-crypt-key
                           │
                    git-crypt unlock 时读取
                           │
                           ▼
                    vars/private.nix 解锁为明文
```

**新机器解锁完整链路：**

1. SSH 私钥 → 解密 `secrets/git-crypt-key.age` → 得到 git-crypt 对称密钥
2. git-crypt 对称密钥 → 解锁 `vars/private.nix` → Nix 可以求值
3. SSH 私钥 → 解密 `secrets/*.age` → 程序可以读取 API key

---

## 安全边界

| 威胁 | 防护 |
|------|------|
| GitHub 仓库泄露 | 密文 push，泄露无影响 |
| 单台机器被入侵 | 只泄露该机器能解密的 secret（不影响其他机器） |
| git-crypt key 泄露 | 必须轮换（`git-crypt rekey`）+ 更新 `secrets/git-crypt-key.age` |
| API key 被滥用 | 轮换 key（`agenix -e`）→ 所有机器 switch 生效 |
| 旧机器退役 | 从 `publicKeys` 移除 → rekey → 该机器彻底失去解密能力 |

---

## 常见问题

**Q: 为什么不用一个系统搞定？**
git-crypt 适合加密文件（透明、工作区友好），agenix 适合加密短 secret（按需解密、不需要 unlock 整个仓库）。各取所长。

**Q: 为什么公钥只允许 ed25519？**
age 工具只支持 ed25519 和 x25519。`ssh-rsa` 不兼容，加入会导致 rekey 失败。

**Q: 为什么不把 API key 也用 git-crypt 加密？**
git-crypt 解锁后所有内容明文可见，无法做到"只解密一个 key"。agenix 可以精细控制每个 secret 的解密权限。

**Q: macOS 重启后 secret 读不到了？**
`/run/` 是临时目录，重启清空。重新 `just switch` 即可重新解密。
