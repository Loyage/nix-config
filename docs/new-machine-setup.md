# 新机器部署指南（AI Agent 可执行版）

> **读者**：运行在新机器上的 AI agent（pi / opencode / claude code 等）。用户已装好任意
> CLI agent 与基础工具（git、ssh）。
>
> **目标**：在新机器上完成本仓库（nix-config）的完整部署：Nix 环境、git-crypt 解锁、
> agenix 机密注册、首次 switch、pi agent 可用。
>
> **相关文档**：
> - `AGENTS.md` — 项目总体约定（**先读**：`mylib.scanPaths`、`git add` 陷阱、`--impure` 说明等）

---

## 0. 先理解为什么新机器安装"没那么容易"了

本仓库现在有 **两套加密系统**，新机器必须按顺序解开，缺一不可：

```
git-crypt                           agenix
─────────                           ──────
vars/private.nix（公网 IP 等）        secrets/*.age（deepseek key、git-crypt key 备份）
   │  透明加密（.gitattributes）       │   age 公钥加密
   │                                  │
clone 后是乱码 → 必须先 unlock        部署时用本机 SSH ed25519 私钥解密
   │                                  │
   ▼                                  ▼
明文 vars/private.nix               /run/agenix/deepseek-api-key
（任何 nix 求值前必须解锁）           （仅当你的公钥已注册并 rekey 后）
```

**三个依赖旧机器的环节**（这就是"没那么容易"的原因）：

| 环节 | 卡点 | 谁提供 |
|------|------|--------|
| ① git-crypt unlock | 对称 key 无法从本机 agenix 拿到（鸡生蛋：未部署前解不了 `.age`） | 旧机器（thinkpad）导出 / 密码管理器 |
| ② publicKeys 注册 | 你的 ed25519 公钥必须加进 `vars/public.nix` 并推送 | 新机器自己生成，推送（需 GitHub SSH 权限） |
| ③ agenix rekey | `.age` 文件目前只加密给旧公钥，必须按新列表重新加密 | 旧机器（thinkpad）上 `agenix -r`，或任何能解密旧文件的机器 |

**流程总览**（🛑 = 需要用户参与，见 0.3）：

```
1 环境检测 → 2 装 Nix → 3 SSH 密钥 + GitHub
→ 4 clone 到 ~/nix-config → 5 git-crypt 解锁(🛑)
→ 6 机器身份(hosts/local / 主机名)
→ 7 注册 agenix 公钥 + thinkpad rekey(🛑)
→ 8 首次部署 → 9 验证 → 10 收尾
```

### 0.1 平台分支

| 步骤 | NixOS (x86_64) | macOS (aarch64) | 远程服务器 (Ubuntu/Debian) |
|------|----------------|-----------------|---------------------------|
| 装 Nix | 跳过（自带） | 官方安装器 | 官方 daemon 安装器 |
| 机器身份 | `hosts/local/`（hostname、GRUB UUID、resume） | `vars.macosHostname` + 系统主机名 | 无需（自动读 `USER`/`HOME`） |
| 首次部署 | `sudo nixos-rebuild switch --flake path:.#nixos --impure` | 引导后用 `darwin-rebuild switch --flake path:.` | `nix run home-manager/master -- switch --flake path:.#remote --impure` |
| 之后日常 | `just switch` | `just switch` | `just switch` |
| agenix 解密路径 | `/run/agenix/...` | `/run/agenix/...`（重启清空） | `${XDG_RUNTIME_DIR}/agenix/...`（通常 `/run/user/1000/...`） |

### 0.2 硬性约定（违反会静默失败）

- **仓库必须 clone 到 `~/nix-config`**。`home/programs/core-tools/default.nix` 用
  `mkOutOfStoreSymlink` 硬编码 `${HOME}/nix-config/config` 生成 `~/.config/*` 符号链接，
  换路径会导致配置不生效。
- **新文件在正式部署前仍必须 `git add`**。本仓库使用的 `path:.` 会读取当前工作区，
  所以未跟踪文件在本机可能也能参与构建；但不提交它们会造成“本机成功、其他机器缺文件”的
  不可复现状态。`hosts/local/` 是有意 gitignore 的例外，因此 NixOS 构建保留 `--impure`。
- **本仓库的部署命令必须使用 `path:.` 作为 flake 路径**。普通的 `.` 会按 Git 仓库
  取源，而 git-crypt 的加密文件在 Git 对象中仍是密文；`path:.` 才会读取工作区中
  已经解锁的明文。执行任何 switch 前仍必须先完成第 5 步。
- **不要把高敏感明文放进 `vars/private.nix`**。`path:.` 会把解锁后的源码复制到
  `/nix/store`，而 Nix store 通常对本机其他用户可读。公网 IP、主机名等低敏感结构化配置
  可以使用 git-crypt；API key、token、密码和私钥必须使用 agenix。git-crypt keyfile
  必须放在仓库外，使用后立即删除。
- **agenix 公钥只允许 `ssh-ed25519`**。加 `ssh-rsa` 会让 rekey 失败/所有机器解密失败。
- **SSH 私钥必须空密码**（`-N ""`）：agenix 由 systemd/activation 非交互解密。

### 0.3 需要用户参与的检查点（提前告诉用户准备）

| # | 时机 | 用户要做什么 |
|---|------|-------------|
| 🛑 A | 第 3 步 | 把新机器公钥加到 GitHub（Settings → SSH and GPG keys） |
| 🛑 B | 第 5 步 | 提供 git-crypt keyfile（thinkpad 导出或密码管理器） |
| 🛑 C | 第 7 步 | 在 thinkpad（或任意已解锁旧机器）执行 rekey 命令 |

> 若用户在开始前已准备好 A/B/C 所需的材料，整个流程可以一口气跑完。

---

## 1. 环境检测

```bash
uname -s -m                       # 平台与架构：Linux x86_64 / Darwin arm64 / Linux aarch64
whoami                            # NixOS/macOS 通常为 loyage；服务器可以是任意目标用户
git --version; ssh -V             # 基础工具
nix --version 2>/dev/null || echo "NIX_NOT_INSTALLED"
test -d ~/nix-config && echo "EXISTS" || echo "OK"
```

- macOS / Ubuntu 若无 `git`/`ssh`：见第 2 步一起处理。
- `~/nix-config` 已存在：**停下来问用户**是继续覆盖还是换个目录（仓库约定固定路径）。
- NixOS：确认当前用户在 `wheel` 组（`groups`），且 `sudo` 可用（`sudo -v`）。

---

## 2. 安装 Nix

### NixOS —— 跳过（自带 nix，且默认启用 flakes）

若后面报 `experimental Nix feature 'nix-command' is disabled`，编辑 `/etc/nix/nix.conf`：

```
experimental-features = nix-command flakes
```

### macOS —— 官方安装器

```bash
xcode-select --install || true    # 若已装会报错，忽略
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --no-daemon
# 重新登录或 source 一下：
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
```

若以后要跑本仓库的 macOS 配置，先装 Rosetta（flake 里 `enableRosetta = true`）：

```bash
sudo softwareupdate --install-rosetta --agree-to-license || true
```

### Ubuntu / Debian（远程服务器）—— daemon 安装器

```bash
sudo apt-get update && sudo apt-get install -y git git-crypt curl
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --daemon
# 新开 shell 或：
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
```

然后给 `/etc/nix/nix.conf` 追加（否则报 "ignoring untrusted substituter / experimental feature disabled"）：

```
experimental-features = nix-command flakes
trusted-users = root <你的用户名>
```

```bash
sudo systemctl restart nix-daemon
```

> 无 sudo 权限的服务器：用 [nix-portable](https://github.com/DavHau/nix-portable)
> （`NP_RUNTIME=proot ./nix-portable nix run ...`），本文件其余命令把 `nix` 换成
> `./nix-portable nix` 即可。

### ✅ 验证

```bash
nix --version
nix eval --raw nixpkgs#hello.name   # 输出 hello 即 flake 可用
```

---

## 3. 生成 SSH 密钥 + GitHub 认证

新机器的 ed25519 私钥 **一钥两用**：GitHub 推送 + agenix 解密身份。

```bash
ssh-keygen -t ed25519 -N "" -f ~/.ssh/id_ed25519 -C "$(whoami)@$(hostname)"
cat ~/.ssh/id_ed25519.pub
```

> ⚠️ `-N ""` 必须：带密码的私钥无法被 agenix 非交互解密。
> ⚠️ 不要复制旧机器的私钥过来，每台机器独立密钥对。

🛑 **USER-ACTION A**：请用户把上面打印的公钥添加到 GitHub（Settings → SSH and GPG keys →
New SSH key，随便起名如 `new-machine`）。

```bash
ssh -T git@github.com || true     # 首次会问 yes，看到 "Hi <user>! You've successfully authenticated" 即 OK
```

---

## 4. 克隆仓库（必须 ~/nix-config）

```bash
git clone git@github.com:Loyage/nix-config.git ~/nix-config
cd ~/nix-config
git log --oneline -3              # ✅ 确认拿到最新
cat docs/new-machine-setup.md | head -5   # ✅ 本文件可读（docs/ 未加密）
```

> 若用户改用 HTTPS clone，后续 push 需要 personal access token，按 `git remote -v`
> 实际情况处理；本文按 SSH 写。

---

## 5. git-crypt 解锁（任何 nix 求值之前！）

`vars/default.nix` 会 `import ./vars/private.nix`，不解锁就是乱码，flake 直接求值失败。

### 5.1 获取 keyfile（三选一）

🛑 **USER-ACTION B**，请用户任选其一提供：

```bash
# 方式一：在已经解锁的 thinkpad 上导出，再通过安全渠道（密码管理器/加密聊天/U盘）传到本机
#   cd ~/nix-config
#   nix shell nixpkgs#git-crypt -c git-crypt status
#   nix shell nixpkgs#git-crypt -c git-crypt export-key /tmp/git-crypt.key
#   rm /tmp/git-crypt.key                                        # 传完后在 thinkpad 删掉
# 若 thinkpad 能 SSH 到本机（openssh 在 2222 端口、公钥已注册），可直传：
#   scp -P 2222 /tmp/git-crypt.key loyage@<本机IP>:~/

# 方式二：从密码管理器取回之前保存的 key 文件

# 方式三：在持有已注册 ed25519 私钥、能解密旧 .age 文件的机器上，从 agenix 备份恢复
#   cd ~/nix-config
#   umask 077
#   agenix -d secrets/git-crypt-key.age -i ~/.ssh/id_ed25519 > /tmp/git-crypt.key
```

> `export-key` 不能从锁定的仓库反向恢复密钥。若报 `Unable to open key file`，当前机器并非
> 已解锁机器，请换一台机器或使用方式二/三。方式三也不能使用尚未注册并 rekey 的新机器密钥。

### 5.2 解锁

```bash
# 本机若还没有 git-crypt，用 nix shell 临时加入整个子进程的 PATH：
nix shell nixpkgs#git-crypt -c git-crypt unlock /path/to/git-crypt.key
# 或已安装：git-crypt unlock /path/to/git-crypt.key
```

> 不要使用 `nix run nixpkgs#git-crypt -- unlock ...`：Git 随后启动 smudge 子进程时可能
> 找不到 `git-crypt`，导致密钥已安装但文件仍未解密。先完成下面的验证，再删除 keyfile。

若 unlock 报 `existing encrypted files have not been decrypted`，说明密钥已写入仓库、但
checkout 中途失败。保持 `git-crypt` 在 PATH 中，只重新检出受保护文件：

```bash
nix shell nixpkgs#git-crypt -c git checkout -- vars/private.nix
# 若还有其他受 git-crypt 保护的文件，逐个执行同样命令。
```

> 不要用 `git checkout -- .`，它可能覆盖其他尚未提交的修改。

### ✅ 验证

```bash
head -5 vars/private.nix           # 应看到明文 Nix 注释（"# 私有配置..."），不是 GITCRYPT 乱码
nix shell nixpkgs#git-crypt -c git-crypt status | grep private
nix eval path:.#homeConfigurations.remote.activationPackage.drvPath --raw --impure >/dev/null
# 上一行实例化完整 Home Manager derivation，证明解锁后的工作区和所有模块均可求值。
rm /path/to/git-crypt.key          # ⚠️ 验证成功后立即删除
```

> 之后 `git pull` 会自动维持解密状态，无需再次 unlock（除非执行过 `git-crypt lock`）。

---

## 6. 机器身份配置

### NixOS（`hosts/local/` 是本机专属、gitignored，必须创建）

```bash
cd ~/nix-config
cp -r hosts/local.example hosts/local
```

**硬件配置**：全新安装时安装器生成的 `/etc/nixos/hardware-configuration.nix` 已随系统
落在 `/etc/nixos/`，直接拷贝：

```bash
if [ -f /etc/nixos/hardware-configuration.nix ]; then
  cp /etc/nixos/hardware-configuration.nix hosts/local/
fi
# 没有则停下来问用户要备份
```

**编辑 `hosts/local/host-user.nix`**：

- `networking.hostName`：改成这台机器的名字（例如 `thinkpad`）。这是 NixOS 主机名的唯一来源。
- GRUB 双系统（若有 Windows）：用 `lsblk -o NAME,UUID,FSTYPE,LABEL,MOUNTPOINTS` 找到
  FAT32 EFI 分区（vfat，通常 LABEL 为 ESP/EFI），把 UUID 填进 `search --fs-uuid`。
  无 Windows：删掉整个 `boot.loader.grub.extraEntries` 块（GRUB 本体已在
  `modules/linux/base.nix` 配好）。
- 休眠 resume：`blkid | grep -i swap` 找到 swap 分区 UUID，填进 `resumeDevice` 与
  `resume=UUID=...`。不启用休眠则删掉这三行。

> 用户是 loyage 且已有 wheel 权限：NixOS 安装器创建用户时请命名为 `loyage`；若当时
> 建了别的名字，先 `sudo useradd -m loyage && sudo passwd loyage && sudo usermod -aG wheel loyage`，
> 然后用 loyage 登录继续。

### macOS

- 若新机器与 `vars/public.nix` 里 `macosHostname`（当前 `LoyagedeMacBook-Air`）不一致：
  - 改 `vars/public.nix` 的 `macosHostname`（这是 flake 输出名，必须匹配）
  - 同步系统主机名：
  ```bash
  sudo scutil --set HostName <name>
  sudo scutil --set LocalHostName <name>
  sudo scutil --set ComputerName <name>
  ```
  - `git add vars/public.nix && git commit -m "chore(vars): update macos hostname" && git push`
- 不用创建 `hosts/local/`（那是 Linux 专用）。

### 远程服务器 —— 无需操作

`home/home-setting.nix` 在 headless profile 下通过 `getEnv "USER"/"HOME"` 自动取当前用户（所以部署
必须带 `--impure`）。确认当前登录用户就是目标用户即可。

---

## 7. 注册新机器到 agenix（核心！）

> 目标：让 `secrets/*.age` 能用新机器的私钥解密。两步：加公钥（本机做）→ rekey（旧机器做）。

### 7.1 追加公钥到 `vars/public.nix`

```bash
cd ~/nix-config
grep -n "publicKeys" -A 6 vars/public.nix   # 查看现有列表
```

编辑 `vars/public.nix`，在 `publicKeys` 列表**末尾**追加第 3 步的公钥：

```nix
publicKeys = [
  # ... 已有条目保持不动 ...
  "ssh-ed25519 AAAA<本机公钥>... <user>@<hostname>"   # ← 新增，仅限 ssh-ed25519！
];
```

```bash
git add vars/public.nix
git commit -m "feat(secrets): add <机器名> ed25519 key for agenix"
git push
```

> ⚠️ 只加 `ssh-ed25519`。不要动 `authorizedKeys`（那是"谁可以 SSH 登录本机"）。
> 可选：想从旧机器 SSH 进新机器，把公钥也加进 `authorizedKeys`。

### 7.2 在旧机器上 rekey（🛑 USER-ACTION C）

`agenix -r` 会先解密、再按**最新** `publicKeys` 重新加密所有 `.age` 文件。必须在
能解密旧文件的机器（thinkpad / macbook）上执行。请用户运行：

```bash
cd ~/nix-config
git pull                                   # 先拉到 7.1 的 publicKeys 变更
cd secrets
agenix -r                                  # 期望输出 rekeying deepseek-api-key.age... rekeying git-crypt-key.age...
cd ..
git add secrets/*.age
git commit -m "feat(secrets): rekey for <机器名>"
git push
```

> `agenix` CLI 已在旧机器上（`modules/base/shell-tools.nix` 装了 system package）。
> 若报错：检查 `publicKeys` 里是否有 `ssh-rsa`（age 不支持）。
> 若无任何旧机器可用：必须从密码管理器/服务商找回明文机密，再用
> `age -e -r "$(cat ~/.ssh/id_ed25519.pub)" -o secrets/<name>.age` 重新加密（会丢失旧机器解密能力）。

### 7.3 拉取 rekey 结果

```bash
cd ~/nix-config
git pull
git log --oneline -2                 # ✅ 应看到 "rekey for <机器名>"
```

---

## 8. 首次部署

> 首次部署前 `just` 可能还没装，所以直接跑原始命令；部署成功后才有 `just`（在
> `modules/base/shell-tools.nix` 的 systemPackages 里）。日常更新直接 `just switch`。

### NixOS

```bash
cd ~/nix-config
sudo nixos-rebuild switch --flake path:.#nixos --impure --show-trace
```

- `--impure` 必须：`hosts/local/` 是 gitignored，纯模式下求值会失败。
- 报 "experimental feature" → 见第 2 步 NixOS 分支。
- 之后日常：`just switch`（= `switch-test` 验证 + `switch`）。

### macOS（引导 + 部署）

```bash
cd ~/nix-config
# 引导：先构建出系统，用系统自带的 darwin-rebuild 激活（使用仓库 pin 的 nix-darwin）
nix build path:.#darwinConfigurations.${macosHostname}.system
./result/sw/bin/darwin-rebuild switch --flake path:.
# 备选引导（用 registry 的 nix-darwin master，版本可能略新）：
# nix run github:lnl7/nix-darwin -- switch --flake path:.
```

之后日常：`just switch`（= `sudo darwin-rebuild switch --flake path:. --show-trace`）。

### 远程服务器

```bash
cd ~/nix-config
# just recipes 会先执行 headless-preflight：检查 git-crypt 文件头并实例化完整 activation derivation。
# x86_64：
nix run home-manager/master -- switch --flake path:.#remote --show-trace --impure -b backup
# aarch64（Graviton/树莓派等）：
nix run home-manager/master -- switch --flake path:.#remote-aarch64 --show-trace --impure -b backup
```

- headless 配置通过全局能力 `hostProfile.graphical = false` 跳过 `home/programs/core-tools/gui`、GUI 配置链接和 Orca；它表达的是“无图形环境”，而不是机器是否通过 SSH 访问
  AppImage；QQ、WeChat、Thunderbird、Zotero、WPS、Kitty、Ghostty、Zathura、Typora、
  Neovide 等不会进入服务器 generation。
- 之后日常统一执行 `just switch`；普通 Linux 会自动选择 `headless` 或 `headless-aarch64`，并判断是否需要通过 `nix run` 首次启动 Home Manager。
- 以目标用户身份执行（headless profile 从 `USER`/`HOME` 获取身份，不在仓库中写死服务器用户名）。

### ✅ 部署日志应出现

```
[agenix] decrypting secrets...
decrypting '.../deepseek-api-key.age' to '.../deepseek-api-key'...
```

---

## 9. 验证

### 9.1 agenix 机密已解密

```bash
# NixOS / macOS：
ls -l /run/agenix/deepseek-api-key        # 0400，属主 loyage
cat /run/agenix/deepseek-api-key          # 输出 sk-... 开头（不要打印到公开渠道）
# 远程服务器：
echo ${XDG_RUNTIME_DIR:-/run/user/$(id -u)}
cat "${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/agenix/deepseek-api-key"
```

### 9.2 配置文件已就位（git-crypt 解锁 + 符号链接生效）

```bash
ls -la ~/.config/nvim                      # 应是指向 ~/nix-config/config/nvim 的符号链接
grep -A2 -i "HostName" ~/.ssh/config       # 由 vars/private.nix 的 sshHosts 生成 → 证明 git-crypt 解锁
ls ~/.agents/skills/                       # 项目 skills 已链接
```

### 9.3 pi agent 可用

```bash
pi
```

无需手动配置：`programs.pi-coding-agent` 已写入 `~/.pi/agent/settings.json`，
`apiKey = "!cat /run/agenix/deepseek-api-key"`（remote 覆盖为 XDG 路径），请求时自动读取。
验证默认 provider/model 能正常对话。

> 可选双保险（与 thinkpad 一致）：手动建 `~/.pi/agent/auth.json`：
> ```json
> { "deepseek": { "type": "api_key", "key": "!cat /run/agenix/deepseek-api-key" } }
> ```
> remote 路径换成 `${XDG_RUNTIME_DIR}/agenix/deepseek-api-key`。不建也没关系。

---

## 10. 收尾（可选）

- 在 `README.md` 的平台表加一行新机器（顺手更新仓库文档）。
- 想让 thinkpad 等旧机器能 SSH 进新机器：把新机器公钥追加到 `vars/public.nix` 的
  `authorizedKeys`，commit + push，各机器 `just switch` 后生效（写的是真实文件，非 symlink）。
- 如果本机是临时环境、以后会销毁：考虑从 `publicKeys` 移除本机公钥并让旧机器再 rekey 一次。

---

## 11. 故障排查

| 症状 | 原因 | 解决 |
|------|------|------|
| `head vars/private.nix` 是 GITCRYPT 乱码 | 没 unlock | 重做第 5 步；确认 keyfile 与 `.gitattributes` 匹配 |
| flake 求值报 `unexpected end of file`/语法错误，路径指向 `vars/private.nix` | 同上 | 先 unlock 再 eval |
| 工作区已解锁，但 `/nix/store/...-source/vars/private.nix` 仍是 GITCRYPT | 使用了 Git 类型的 `.#...` flake source | 改用 `path:.#...`；仓库的 Justfile 已统一处理 |
| unlock 后提示已设置密钥、但现有文件未解密 | `nix run` 启动的 smudge 子进程找不到 `git-crypt` | 用 `nix shell nixpkgs#git-crypt -c git checkout -- vars/private.nix` |
| `git-crypt export-key` 报 `Unable to open key file` | 当前仓库从未成功解锁 | 换到已解锁旧机器导出，或从密码管理器/agenix 备份恢复 |
| 部署日志 `[agenix] decrypting` 失败 / 找不到 key | 公钥没进 `publicKeys`，或 rekey 后没 pull | 重做第 7 步；确认是 `ssh-ed25519` |
| 旧机器 `agenix -r` 报错 | `publicKeys` 混入了 `ssh-rsa` | 移除 rsa 条目后重跑 `agenix -r` |
| `nixos-rebuild` 提示 flake 里没有 `.#nixos` | `hosts/local/` 不存在 | 重做第 6 步 NixOS 分支 |
| `nixos-rebuild` 报 hosts/local 路径错误 | 没带 `--impure` | 首次部署必须带 `--impure` |
| `nix` 报 experimental feature disabled | 未启用 flakes/nix-command | 见第 2 步 nix.conf 配置 |
| `pi` 提示 `Provider is not configured: deepseek` | agenix 未解密或路径错 | 重查 9.1；`sudo systemctl restart agenix.service` 或重跑 switch |
| remote 上 `$XDG_RUNTIME_DIR` 为空 | 无 systemd 登录会话 | 重新登录 SSH / `sudo systemctl start systemd-logind` |
| macOS 重启后 `/run/agenix` 空了 | `/run` 是临时目录，重启清空 | 重新 `just switch` 即重新解密 |
| GitHub clone/push 报 permission denied | 新机器公钥未加到 GitHub | 🛑 USER-ACTION A |
| `git-crypt unlock` 报 key 无效 | keyfile 与仓库不匹配 | 换从 thinkpad 重新 `git-crypt export-key` |

---

## 12. 最终自检清单

- [ ] `uname -s -m` 与目标平台一致；服务器上 `whoami` 是希望配置的目标用户
- [ ] `~/nix-config` 存在，`git log` 有最新提交
- [ ] `head vars/private.nix` 是明文
- [ ] `just headless-preflight headless` 通过（无 sudo、无图形服务器）
- [ ] 公钥已进 `vars/public.nix` 的 `publicKeys` 且已 push
- [ ] `git log --oneline -2` 显示 rekey 提交已拉到
- [ ] 首次部署日志有 `[agenix] decrypting...`
- [ ] `cat /run/agenix/deepseek-api-key`（或 XDG 路径）输出 `sk-...`，权限 0400
- [ ] `pi` 启动且 deepseek 对话正常
- [ ] `~/.config/nvim` 是指向 `~/nix-config/config/nvim` 的符号链接
