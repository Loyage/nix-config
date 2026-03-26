# nix-config

基于 Nix Flake 的跨平台配置管理，支持 NixOS、macOS (nix-darwin) 和远程 Linux 服务器 (home-manager standalone)。

## 支持的平台

| 配置 | 平台 | Flake 输出 |
|------|------|------------|
| ThinkPad | NixOS x86_64 | `nixosConfigurations.thinkpad` |
| Legion | NixOS x86_64 | `nixosConfigurations.legion` |
| MacBook Air | macOS aarch64 | `darwinConfigurations.LoyagedeMacBook-Air` |
| 远程服务器 | Linux x86_64 | `homeConfigurations.remote` |
| 远程服务器 (ARM) | Linux aarch64 | `homeConfigurations.remote-aarch64` |

---

## 本地机器

### NixOS

```bash
# 构建并切换配置
sudo nixos-rebuild switch --flake .

# 或使用 just
just switch
```

### macOS

```bash
# 构建并切换配置
sudo darwin-rebuild switch --flake .

# 或使用 just
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

### 首次部署

**第一步：安装 Nix**

```bash
curl -L https://nixos.org/nix/install | sh
# 重新加载 shell 或新开一个终端
```

**第二步：克隆配置仓库**

```bash
git clone <your-repo-url> ~/nix-config
cd ~/nix-config
```

**第三步：激活 home-manager 配置**

```bash
# x86_64 服务器（最常见）
nix run home-manager/master -- switch --flake .#remote

# aarch64 服务器（如 AWS Graviton、树莓派）
nix run home-manager/master -- switch --flake .#remote-aarch64
```

> 首次运行会下载所有依赖，耗时较长，请耐心等待。

**第四步：切换到 zsh**

```bash
chsh -s $(which zsh)
# 重新登录后生效
```

### 后续更新

```bash
cd ~/nix-config
git pull

# 更新配置
home-manager switch --flake .#remote

# 或使用 just（需要在远程服务器上安装 just）
just remote-switch
```

### 仅更新 flake 依赖

```bash
nix flake update
home-manager switch --flake .#remote
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
├── modules/               # NixOS / darwin 系统模块
├── home/
│   ├── base/              # 所有平台共享的 home-manager 配置
│   ├── linux/             # NixOS 专用（桌面环境等）
│   ├── darwin/            # macOS 专用
│   └── remote/            # 远程服务器专用（SSH 开发环境）
├── hosts/                 # 各主机硬件配置
└── pkgs/                  # 自定义 nix 包
```