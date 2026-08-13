# 多机器使用 pi agent（deepseek API key via agenix）

本仓库用 **agenix** 加密存储 pi agent 的 deepseek API key，任何一台新机器只需
把自己的 ed25519 公钥加进 `vars/default.nix`，部署后即可直接使用 pi。

---

## 一、原理

```
secrets/deepseek-api-key.age   ← age 加密的 key（git 已跟踪，非机密）
        │
        │ 每台机器部署时，agenix 用本机 SSH ed25519 私钥解密
        ▼
/run/agenix/deepseek-api-key   ← 解密后的 key（0400，仅本用户可读）
        │
        │ pi 的 "!command" 语法在请求时执行 cat 读取
        ▼
pi → deepseek API（认证成功）
```

- **明文 key 只存在于**：加密文件（git）和每台机器解密后的临时文件（tmpfs，重启消失）
- **pi 配置双保险**：
  - `~/.pi/agent/auth.json`（本地，优先级最高）：`"key": "!cat <路径>"`
  - `~/.pi/agent/settings.json`（nix 声明式，自动部署）：`providers.deepseek.apiKey = "!cat <路径>"`（remote 会覆盖为 XDG 路径）

### 各平台解密路径

| 平台 | agenix 类型 | 解密路径 |
|------|------------|---------|
| NixOS（thinkpad） | 系统级 | `/run/agenix/deepseek-api-key` |
| macOS（MacBook Air） | darwin 系统级 | `/run/agenix/deepseek-api-key` |
| 远程服务器（Ubuntu/Debian） | home-manager 级 | `${XDG_RUNTIME_DIR}/agenix/deepseek-api-key`（通常 `/run/user/1000/agenix/...`） |

---

## 二、新机器上线步骤

> 前提：机器上已部署好本仓库（NixOS/macOS 跑过 `just switch`，remote 跑过
> `just remote-init` 或 `just remote-switch`），且 `~/nix-config` 存在。

### 1. 生成 ed25519 密钥（每台机器独立，只做一次）

```bash
ssh-keygen -t ed25519 -N "" -f ~/.ssh/id_ed25519 -C "$(whoami)@$(hostname)"
```

- `-N ""` 必须为空密码：agenix 由 systemd/activation 非交互解密，带密码的私钥无法使用
- **不要**复制别台机器的私钥过来；每台机器用自己的密钥对

### 2. 把公钥加进 `vars/default.nix`

```bash
cat ~/.ssh/id_ed25519.pub
```

编辑 `vars/default.nix`，把输出的公钥追加到 `publicKeys` 列表：

```nix
publicKeys = [
  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII5mat02... loyage@thinkpad"  # 已有
  "ssh-ed25519 AAAA新机器公钥... loyage@macbook"                     # 新增
];
```

> ⚠️ **只能加 `ssh-ed25519` 类型的公钥**。age/agenix 不支持 `ssh-rsa`（加了会导致所有机器解密失败）。

### 3. 在能解密旧文件的机器上 rekey（重要！）

`agenix -r` 会先解密再按新的 `publicKeys` 重新加密所有 `.age` 文件。
**必须在已有私钥能解密旧文件的机器上执行**（通常是 thinkpad，因为新机器的公钥还没加密进去，它自己解不了）：

```bash
cd ~/nix-config/secrets
agenix -r    # 系统已装 agenix CLI（或 nix run .#agenix -- -r）
```

看到 `rekeying deepseek-api-key.age...` 即成功。

### 4. 提交并推送

```bash
cd ~/nix-config
git add vars/default.nix secrets/*.age
git commit -m "feat(secrets): add <机器名> ed25519 key for agenix"
git push
```

### 5. 新机器拉取并部署

| 平台 | 命令 |
|------|------|
| NixOS | `cd ~/nix-config && git pull && just switch` |
| macOS | `cd ~/nix-config && git pull && just switch` |
| 远程服务器 | `cd ~/nix-config && git pull && just remote-switch`（首次用 `remote-init`） |

部署日志中应出现：

```
[agenix] decrypting secrets...
decrypting '.../deepseek-api-key.age' to '.../deepseek-api-key'...
```

### 6. 验证

```bash
# NixOS / macOS
cat /run/agenix/deepseek-api-key
# 远程服务器
cat "${XDG_RUNTIME_DIR}/agenix/deepseek-api-key"
```

输出应为 `sk-...` 开头的 key（不会显示明文以外的内容即可）。权限应为 `0400`、属主为你的用户。

### 7. 启动 pi

```bash
pi
```

直接使用即可。**无需手动配置**：`settings.json` 由 nix 自动写入，pi 会通过
`!cat` 读取解密后的 key。

> 可选（双保险，与 thinkpad 保持一致）：手动创建 `~/.pi/agent/auth.json`：
> ```json
> {
>   "deepseek": {
>     "type": "api_key",
>     "key": "!cat /run/agenix/deepseek-api-key"
>   }
> }
> ```
> 注意 remote 服务器路径改为 `${XDG_RUNTIME_DIR}/agenix/deepseek-api-key`。
> 不创建也没关系，`settings.json` 已兜底。

---

## 三、故障排查

| 症状 | 原因 | 解决 |
|------|------|------|
| `pi` 提示 `Provider is not configured: deepseek` | agenix 没解密成功，`cat <路径>` 为空/失败 | 检查第 6 步验证路径；确认 `just switch` 日志有 `[agenix] decrypting`；`sudo systemctl restart agenix.service` 或重跑 switch |
| 部署时 `[agenix] decrypting` 失败 | 这台机器的公钥没加进 `publicKeys`，或 rekey 后没拉取 | 重做第 2-5 步；确认 `publicKeys` 里是 `ssh-ed25519` |
| 所有机器都解密失败 | 有人加了 `ssh-rsa` 公钥进 `publicKeys` | 移除 rsa 公钥，重新 `agenix -r` |
| remote 上 pi 读不到 key | `$XDG_RUNTIME_DIR` 未设置（无 systemd 登录会话） | `echo $XDG_RUNTIME_DIR` 检查；用 `sudo systemctl start systemd-logind` 或重新登录 SSH；确认是 `remote-switch` 而不是系统级部署 |
| macOS 重启后 key 丢失 | `/run`（/private/var/run）重启被清理 | 重新 `just switch`（agenix 会重新解密）；或按 agenix darwin 文档配置开机自动激活 |
| 换新 deepseek key 后仍用旧 key | pi 缓存了命令结果（进程生命周期内） | 重启 pi；`!cat` 结果按进程缓存 |

---

## 四、日常维护

### 更换 deepseek API key

```bash
cd ~/nix-config/secrets
agenix -e deepseek-api-key.age    # 用 $EDITOR 编辑明文，保存后自动加密
cd ~/nix-config
just switch-test && just switch   # 重新解密到各平台路径
```

### 新增一个机密（以数据库密码为例）

```bash
# 1. 加密
echo -n "my-password" | age -e -r "$(cat ~/.ssh/id_ed25519.pub)" -o secrets/db-password.age
```

```nix
# 2. secrets/secrets.nix 注册
{
  "deepseek-api-key.age".publicKeys = keys;
  "db-password.age".publicKeys = keys;
}
```

```nix
# 3. modules/base/secrets.nix 定义（remote 需要的话在 home/remote-server.nix 同样定义）
age.secrets.db-password = {
  file = ../../secrets/db-password.age;
  mode = "0400";
  owner = myvars.username;
};
```

```bash
# 4. 应用
git add secrets/db-password.age && just switch
```

### 权限说明

- `secrets/*.age`：加密文件，**可以**提交 git
- `~/.pi/agent/auth.json`：本机运行时文件（600），包含 `!cat` 命令但不含明文 key，不入库
- `vars/default.nix` 的 `publicKeys`：公钥，公开无妨
