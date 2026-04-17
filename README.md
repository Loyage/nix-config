# nix-config

基于 Nix Flake 的跨平台配置管理，支持 NixOS、macOS (nix-darwin) 和远程 Linux 服务器 (home-manager standalone)。

## 支持的平台

| 配置 | 平台 | Flake 输出 |
|------|------|------------|
| ThinkPad | NixOS x86_64 | `nixosConfigurations.thinkpad` |
| Legion | NixOS x86_64 | `nixosConfigurations.legion` |
| MacBook Air | macOS aarch64 | `macosConfigurations.LoyagedeMacBook-Air` |
| 远程服务器 | Linux x86_64 | `homeConfigurations.remote` |
| 远程服务器 (ARM) | Linux aarch64 | `homeConfigurations.remote-aarch64` |

---

## 本地机器

### NixOS

```bash
sudo nixos-rebuild switch --flake .
# 或
just switch
```

### macOS

```bash
sudo darwin-rebuild switch --flake .
# 或
just switch
```

---

## 远程服务器（Ubuntu / Debian）

在远程服务器上通过 home-manager standalone 快速部署开发环境，包含：

- **Shell**：zsh + oh-my-zsh + oh-my-posh
- **编辑器**：neovim（使用 `~/nix-config/config/nvim` 配置）
- **文件管理**：yazi（catppuccin-mocha 主题）
- **版本控制**：git + lazygit
- **终端复用**：zellij
- **常用工具**：bat、btop、fzf、ripgrep、zoxide、eza、dust、duf 等

### 首次部署（有 Sudo 权限）

```bash
# 1. 安装 Nix
curl -L https://nixos.org/nix/install | sh
# 重新加载 shell 或新开终端

# 2. 克隆配置仓库
git clone <your-repo-url> ~/nix-config

# 3. 激活 home-manager 配置
#    x86_64 服务器（最常见）
nix run home-manager/master -- switch --flake ~/nix-config#remote
#    aarch64 服务器（AWS Graviton、树莓派等）
nix run home-manager/master -- switch --flake ~/nix-config#remote-aarch64

# 可能遇到的问题：
error: experimental Nix feature 'nix-command' is disabled; add '--extra-experimental-features nix-command' to enable it
# 解决方案：给 `/etc/nix/nix.conf` 添加以下内容：
experimental-features = nix-command flakes
# 并重启 Nix 服务：
sudo systemctl restart nix-daemon

```

### 首次部署（无 Sudo 权限）

如果你在远程服务器上没有 `sudo` 权限，无法在根目录创建 `/nix`，请使用 [nix-portable](https://github.com/DavHau/nix-portable)：

```bash
# 1. 下载 nix-portable
curl -L https://github.com/DavHau/nix-portable/releases/latest/download/nix-portable-$(uname -m) > ~/nix-portable
chmod +x ~/nix-portable

# 2. 初始化环境（使用 nix-portable 代替 nix）
#    x86_64 服务器
./nix-portable nix run home-manager/master -- switch --flake ~/nix-config#remote
#    aarch64 服务器
./nix-portable nix run home-manager/master -- switch --flake ~/nix-config#remote-aarch64

# 3. 后续使用
# 你可以设置别名方便调用：alias nix="~/nix-portable nix"

#### 常见问题：Operation not permitted
如果在运行 `./nix-portable` 时报错 `setting up a private mount namespace: Operation not permitted`，说明服务器禁用了用户命名空间。请强制使用 proot 模式：
```bash
NP_RUNTIME=proot ./nix-portable <command>
```

```

### 切换默认 Shell

```bash
# 有 sudo 权限
chsh -s $(which zsh)

# 无 sudo 权限：在 ~/.bashrc 或 ~/.profile 中添加
# if [ -x "$(command -v zsh)" ]; then
#   exec zsh
# fi
```

> 首次运行会下载所有依赖，耗时较长，请耐心等待。

### 后续更新

```bash
cd ~/nix-config && git pull
home-manager switch --flake .#remote
# 或
just remote-switch
```

---

## 项目结构

```
nix-config/
├── flake.nix              # Flake 入口，定义所有输出
├── flake.lock
├── Justfile               # 常用命令快捷方式
├── vars/                  # 全局变量（用户名、主机列表等）
├── lib/                   # 辅助函数
├── config/                # 应用配置文件（nvim、zsh、lazygit 等）
├── modules/               # NixOS / macos 系统模块
├── home/
│   ├── tui-base/          # 共享终端开发环境（所有平台调用）
│   │   ├── git.nix
│   │   └── programs/      # nvim、yazi、zsh、eza、ohmyposh 等
│   ├── gui-base/          # 桌面机器扩展（在 tui-base 基础上加桌面工具）
│   │   └── programs/      # ai-tools、gui-tools、剪贴板绑定等
│   ├── linux/             # NixOS 专用（桌面环境、输入法等）
│   ├── macos/             # macOS 专用
│   └── remote/            # 远程服务器入口（直接调用 tui-base）
├── hosts/                 # 各主机硬件配置
└── pkgs/                  # 自定义 nix 包
```

### home 层级关系

```
remote  ──────────────────────→  tui-base
linux   →  gui-base  ─────────────→  tui-base
macos   →  gui-base  ─────────────→  tui-base
```
