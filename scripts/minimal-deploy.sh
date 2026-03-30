#!/usr/bin/env bash

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}==> 开始全量部署 (包含 Oh My Zsh & Oh My Posh)${NC}"

# 1. 基础依赖检查与个人包管理器安装
install_manager() {
    echo -e "${BLUE}检测到无 sudo 权限，建议安装 Micromamba (推荐) 或 Homebrew...${NC}"
    echo "1) Micromamba (最快)"
    echo "2) Homebrew (最全)"
    echo "3) 跳过"
    read -p "选择 (1/2/3): " choice
    case $choice in
        1) "${SHELL}" <(curl -L micro.mamba.pm/install.sh) ;;
        2) git clone https://github.com/Homebrew/brew ~/.linuxbrew/Homebrew
           mkdir -p ~/.linuxbrew/bin && ln -s ../Homebrew/bin/brew ~/.linuxbrew/bin/ ;;
    esac
}

if ! sudo -n true 2>/dev/null; then install_manager; fi

# 2. 建立配置软链接
echo -e "${BLUE}==> 正在创建配置软链接...${NC}"
CONF_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../config" && pwd)"
TARGET_DIR="$HOME/.config"
mkdir -p "$TARGET_DIR"

configs=("nvim" "btop" "lazygit" "zellij" "zsh" "ohmyposh" "kitty")
for conf in "${configs[@]}"; do
    if [ -d "$CONF_DIR/$conf" ]; then
        echo -e "链接 $conf -> $TARGET_DIR/$conf"
        rm -rf "$TARGET_DIR/$conf"
        ln -s "$CONF_DIR/$conf" "$TARGET_DIR/$conf"
    fi
done

# 3. 安装 Oh My Zsh 及插件
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo -e "${BLUE}==> 正在安装 Oh My Zsh...${NC}"
    git clone https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh" --depth=1
fi

echo -e "${BLUE}==> 正在下载 Zsh 插件...${NC}"
mkdir -p "$ZSH_CUSTOM/plugins"
plugins=(
    "zsh-autosuggestions:https://github.com/zsh-users/zsh-autosuggestions"
    "zsh-syntax-highlighting:https://github.com/zsh-users/zsh-syntax-highlighting"
    "fast-syntax-highlighting:https://github.com/zdharma-continuum/fast-syntax-highlighting"
    "you-should-use:https://github.com/MichaelAquilina/zsh-you-should-use"
)

for p in "${plugins[@]}"; do
    name="${p%%:*}"
    url="${p#*:}"
    if [ ! -d "$ZSH_CUSTOM/plugins/$name" ]; then
        echo "安装插件: $name"
        git clone "$url" "$ZSH_CUSTOM/plugins/$name" --depth=1
    fi
done

# 4. 生成 .zshrc (模拟 Nix/Home-manager 的注入行为)
echo -e "${BLUE}==> 生成 .zshrc...${NC}"
cat > "$HOME/.zshrc" <<EOF
# --- 基础路径设置 ---
export ZSH="\$HOME/.oh-my-zsh"
export ZSH_CUSTOM="\$ZSH/custom"

# --- 插件列表 ---
plugins=(
  git sudo web-search dirhistory
  zsh-autosuggestions
  zsh-syntax-highlighting
  fast-syntax-highlighting
  you-should-use
)

# --- 启动 Oh My Zsh ---
source "\$ZSH/oh-my-zsh.sh"

# --- 加载你的自定义配置 (00-init.zsh 会加载后续所有文件) ---
if [ -f "\$HOME/.config/zsh/00-init.zsh" ]; then
  source "\$HOME/.config/zsh/00-init.zsh"
fi

# --- 初始化 Oh My Posh ---
if command -v oh-my-posh &> /dev/null; then
  eval "\$(oh-my-posh init zsh --config \$HOME/.config/ohmyposh/zen.toml)"
fi

# --- 环境变量补丁 ---
[ -f "\$HOME/.local/bin" ] && export PATH="\$HOME/.local/bin:\$PATH"
EOF

echo -e "${GREEN}==> 部署完成！${NC}"
echo -e "${BLUE}提示: 如果没有 oh-my-posh，请在安装完 micromamba/brew 后运行相应的安装命令。${NC}"
