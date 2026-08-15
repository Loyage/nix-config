# 更换加密数据指南（AI Agent 可执行版）

> **读者**：运行在本仓库任意机器上的 AI agent（pi / openclaude / codex 等），或想了解
> 原理的维护者本人。用户需要更换/轮换某个机密（如 DeepSeek API key、sshHosts、
> git-crypt key 等）时，可直接把本文件交给 agent 执行。
>
> **目标**：掌握本仓库两套加密系统（agenix / git-crypt）的**内容更换**与**接收者更换**
> 操作，并知道每步的验证方法。
>
> **相关文档**：
> - `AGENTS.md` — 项目总体约定（**先读**：`git add` 陷阱、`--impure` 说明等）
> - `docs/new-machine-setup.md` — 新机器首次部署（含公钥注册与 rekey 的完整背景）

---

## 0. 先理解：两套加密，各管什么

```
                    agenix（非对称，按文件加密）
                    ───────────────────────────
secrets/*.age  ──►  每个 .age 是一个独立"容器"：
                      • 内容 = 明文（如 DeepSeek API key）
                      • 接收者 = vars/public.nix 的 publicKeys（全部机器的 ssh-ed25519 公钥）
                      • 解密 = 每台机器用**自己的 SSH 私钥**（identityPaths）在 switch 时自动解密
                      • 消费方读取：/run/agenix/<name>（NixOS/macOS）或
                        ${XDG_RUNTIME_DIR}/agenix/<name>（remote home-manager）

                    git-crypt（对称，透明层）
                    ────────────────────────
vars/private.nix  ─►  .gitattributes 指定的文件，git 里存密文、工作区显示明文
                      • 解锁 = git-crypt unlock <keyfile>（keyfile 由 agenix 备份在
                        secrets/git-crypt-key.age）
                      • 改内容 = 直接编辑明文 → commit 即完成（无需 rekey）
```

**核心心智模型：agenix 有"内容"和"接收者"两个正交维度**

| 操作 | 命令 | 效果 |
|------|------|------|
| 换**内容**（改 key、改配置值） | `agenix -e secrets/<name>.age` | 接收者不变，只换明文 |
| 换**接收者**（加/删机器） | `vars/public.nix` 改 publicKeys → `agenix -r` | 内容不变，重新加密给新列表 |
| 新增一个机密 | `secrets/secrets.nix` 注册 + `age -e` 建文件 + `agenix -r` + 运行时定义 | 见场景 B |
| git-crypt 换内容 | 直接编辑 `vars/private.nix` → commit | 透明加密，无需额外命令 |
| git-crypt 换对称 key | `git-crypt rekey`（低频，高风险） | 见场景 D |

**硬性约定**（违反会失败）：
- agenix 公钥**只允许 `ssh-ed25519`**（`ssh-rsa` 会让 rekey/解密失败）。
- `agenix -r` 必须在**能解密旧文件**的机器上执行（本机、thinkpad 或 macbook 均可）。
- 轮换"全机器共享"的机密（如 DeepSeek API key）后，**旧值通常立即失效**，必须尽快让
  **所有机器**都 switch，否则未切换的机器继续用旧值直到被服务商禁用。
- 机密明文**不要打印进 agent 日志/对话**；验证一律用 `head -c4` 之类的截断输出。

---

## 1. 通用前置（每个场景都先做）

```bash
cd ~/nix-config
git status --short          # 工作区必须干净（有未提交改动先停下来问用户）
git pull                    # 拉到最新（多机协作时务必）
```

解密身份：本机默认 `~/.ssh/id_ed25519`（已在 `modules/base/secrets.nix` 的
`age.identityPaths` 里）。若本机没有能解密的身份，停下来问用户用哪台机器操作。

---

## 2. 场景 A：更换已有 agenix 机密的内容（最常用，如轮换 DeepSeek API key）

### A.1 非交互式更换（agent 推荐，避免 $EDITOR 阻塞）

```bash
cd ~/nix-config/secrets
# 明文通过 stdin 传入；agenix 检测到 stdin 非终端时自动用 cp 代替 $EDITOR
printf '%s' '<新明文，如新 sk-xxx>' | agenix -e deepseek-api-key.age -i ~/.ssh/id_ed25519
# 期望输出：无（静默成功）。文件未变化时输出 "wasn't changed, skipping re-encryption."
```

> 交互式等效命令：`agenix -e secrets/deepseek-api-key.age -i ~/.ssh/id_ed25519`（用 $EDITOR
> 打开明文，整行替换后保存退出，agenix 自动按当前 publicKeys 重新加密）。
> 换 `secrets/git-crypt-key.age` 也是同一流程（文件里是 git-crypt 对称 key 的文本）。

### A.2 验证加密文件

```bash
cd ~/nix-config
agenix -d secrets/deepseek-api-key.age -i ~/.ssh/id_ed25519 | head -c4
# 期望输出：新值开头（如 sk-4）。与 A.1 输入一致即成功。
```

### A.3 提交并推送

```bash
git add secrets/deepseek-api-key.age
git commit -m "chore(secrets): 轮换 deepseek API key"
git push
```

### A.4 各机器应用（旧值失效前尽快全部执行）

```bash
just switch          # 本机 / thinkpad / macbook（各自跑各自的）
just remote-switch   # 每台远程服务器（以目标用户身份）
```

每台 switch 时 agenix 重新解密出新值：
- `/run/agenix/deepseek-api-key`（NixOS/macOS）或 `${XDG_RUNTIME_DIR}/agenix/...`（remote）
- pi agent 的 `apiKey = "!cat <path>"` 自动指向新值，无需改配置
- dsh（DeepSeek Harness）：`dsh-setup.service` 会在 switch 激活时自动把新值写进
  `~/.dsh/.credentials.yaml`；若想立即生效（不等 switch），手动执行：

  ```bash
  umask 077
  printf 'DEEPSEEK_API_KEY: %s\n' "$(cat /run/agenix/deepseek-api-key)" > ~/.dsh/.credentials.yaml
  ```

### A.5 验证本机生效

```bash
head -c4 /run/agenix/deepseek-api-key        # 新值开头
head -c4 ~/.dsh/.credentials.yaml 2>/dev/null # dsh 凭据也已更新（文件内容为 DEEPSEEK_API_KEY: sk-...）
```

---

## 3. 场景 B：新增一个 agenix 机密

四步：注册接收者 → 建加密文件 → rekey 到全部机器 → 加运行时定义与消费方。

### B.1 在 `secrets/secrets.nix` 注册（接收者默认 = 全部机器公钥）

```nix
{
  "deepseek-api-key.age".publicKeys = keys;   # ← 已有
  "git-crypt-key.age".publicKeys = keys;      # ← 已有
  "new-secret.age".publicKeys = keys;         # ← 新增
}
```

### B.2 先用 age 创建加密文件（只加密给自己即可，B.3 会 rekey 到全部机器）

```bash
cd ~/nix-config/secrets
umask 077
printf '%s' '<明文内容>' | age -e -r "$(cat ~/.ssh/id_ed25519.pub)" -o new-secret.age
# 注意：必须是 ssh-ed25519 公钥；age 来自 agenix 依赖，路径见 agenix --help 输出
```

### B.3 rekey 到全部机器

```bash
agenix -r -i ~/.ssh/id_ed25519
# 期望输出：rekeying new-secret.age... rekeying deepseek-api-key.age... rekeying git-crypt-key.age...
# 注意：新文件也出现在列表里才说明 B.1 注册成功
```

### B.4 添加运行时定义

- **系统级（NixOS / macOS）**：`modules/base/secrets.nix` 追加：

  ```nix
  age.secrets.new-secret = {
    file = ../../secrets/new-secret.age;
    mode = "0400";
    owner = myvars.username;
  };
  ```

- **远程服务器**：`home/remote-server.nix` 追加（home-manager 级，解密路径为
  `${XDG_RUNTIME_DIR}/agenix/new-secret`）：

  ```nix
  age.secrets.new-secret = {
    file = ../../secrets/new-secret.age;
    mode = "0400";
  };
  ```

### B.5 消费方引用（示例：pi agent 模型 key）

```nix
programs.pi-coding-agent.settings.models.providers.<provider>.apiKey =
  "!cat ${config.age.secrets.new-secret.path}";
```

### B.6 提交、推送、各机器 switch（同 A.3 / A.4）

```bash
git add secrets/ vars/ modules/ home/
git commit -m "feat(secrets): 新增 new-secret"
git push
# 然后各机器 just switch / just remote-switch
```

---

## 4. 场景 C：更换接收者（新增/移除机器的解密能力）

> 新机器完整流程见 `docs/new-machine-setup.md` 第 7 步；这里只讲"换接收者"本身。

### C.1 改 `vars/public.nix` 的 `publicKeys`

```nix
publicKeys = [
  # ...已有条目保持不动...
  "ssh-ed25519 AAAA<新增机器公钥>... user@host"   # 新增机器（仅限 ssh-ed25519）
  # 移除机器 = 删掉对应行
];
```

```bash
git add vars/public.nix
git commit -m "chore(vars): 更新 agenix 接收者列表"
git push
```

### C.2 在能解密旧文件的机器上 rekey

```bash
cd ~/nix-config
git pull
cd secrets
agenix -r -i ~/.ssh/id_ed25519
# 期望输出：每个 .age 都 rekeying 一遍（即使内容没变）
cd ..
git add secrets/*.age
git commit -m "chore(secrets): rekey 以更新接收者列表"
git push
```

> ⚠️ 移除机器 = 从 publicKeys 删掉它的公钥后 rekey，该机器从此**无法再解密**任何 .age
> 文件（包括 git-crypt-key.age → 连 git-crypt 解锁能力一起丢）。
> 若 `agenix -r` 报错：检查 publicKeys 是否混入 `ssh-rsa`。

---

## 5. 场景 D：修改 git-crypt 加密的 `vars/private.nix`

### D.1 解锁状态直接编辑（最常见）

解锁状态下工作区就是明文，改完正常提交即可（git-crypt 在 commit 时透明加密）：

```bash
head -5 vars/private.nix          # 明文注释 = 已解锁
# 编辑 vars/private.nix（如改 sshHosts 公网 IP、用户名等）...
git add vars/private.nix
git commit -m "chore(vars): 更新私有配置"
git push
```

各机器 `git pull` 后自动看到明文（持 key 的机器），`just switch` 生效。

### D.2 若处于锁定状态（检出是乱码）

```bash
# 从 agenix 备份拿 keyfile（secrets/git-crypt-key.age 里就是 git-crypt 对称 key）
agenix -d secrets/git-crypt-key.age -i ~/.ssh/id_ed25519 > /tmp/git-crypt.key
git-crypt unlock /tmp/git-crypt.key
rm /tmp/git-crypt.key             # 用完即删
# 然后按 D.1 编辑提交
```

### D.3 新增要加密的文件

`vars/private.nix` 之外的新文件需要手动加入加密（.gitattributes 追加一行）：

```
path/to/file filter=git-crypt diff=git-crypt
```

```bash
git-crypt status | grep <新文件>   # 应显示 "encrypted: ..."
```

### D.4 轮换 git-crypt 对称 key（低频，高风险）

```bash
git-crypt rekey                   # 重新生成 key 并重加密全部文件
# ⚠️ 旧 keyfile 立即作废；所有机器需重新 unlock
git-crypt export-key /tmp/git-crypt.key
# 用 agenix 更新备份（场景 A 流程）：
printf '%s' "$(cat /tmp/git-crypt.key)" | agenix -e secrets/git-crypt-key.age -i ~/.ssh/id_ed25519
rm /tmp/git-crypt.key
# 提交 rekey 后的所有加密文件 + 更新后的 .age 备份
```

> 单人多机场景一般**不需要** rekey（key 没泄露就别动）；若怀疑泄露再执行，且要立即
> 通知所有机器更新 keyfile。

---

## 6. 常见错误与排查

| 症状 | 原因 | 解决 |
|------|------|------|
| `agenix -e` 报 cannot decrypt | 本机私钥不在该 .age 的接收者列表（或非 ed25519） | 换能解密的机器操作；或先做场景 C 把本机公钥加进去并 rekey |
| `agenix -r` 报错 | publicKeys 混入 `ssh-rsa` | 移除 rsa 条目后重跑 |
| `agenix -r` 没有 rekey 新文件 | `secrets/secrets.nix` 没注册 | 补 B.1 后重跑 |
| `agenix -e` 输入后提示 unchanged | 内容没变（diff 相同） | 确认 stdin 内容确实与旧值不同 |
| 改完 switch 后 pi 仍用旧 key | 该机器没 switch / agenix 未重解密 | 重跑 `just switch`；检查 `/run/agenix/<name>` 内容 |
| dsh 里没有默认 API | `~/.dsh/.credentials.yaml` 未重写 | switch 后 dsh-setup 会自动重写；或手动执行 A.4 的 printf 命令 |
| remote 上读不到新值 | 路径是 `${XDG_RUNTIME_DIR}/agenix/...` 不是 `/run/agenix/...` | 用 `echo ${XDG_RUNTIME_DIR:-/run/user/$(id -u)}` 确认路径 |
| `head vars/private.nix` 是 GITCRYPT 乱码 | 处于锁定状态 | 按 D.2 unlock |

---

## 7. 最终自检清单（agent 收尾时逐条核对）

- [ ] 工作区干净（`git status --short` 无意外文件），改动已 `git commit` + `git push`
- [ ] `agenix -d <改过的.age> -i ~/.ssh/id_ed25519 | head -c4` 输出新值开头
- [ ] 本机 `/run/agenix/<name>` 已是新值（或 remote 的 XDG 路径）
- [ ] 共享 key 轮换后，**所有**机器的 switch / remote-switch 都已执行（或已明确告知用户执行）
- [ ] dsh 机器上 `~/.dsh/.credentials.yaml` 已更新（switch 或手动）
- [ ] 敏感明文没有出现在本文件、git log、agent 对话或日志中
