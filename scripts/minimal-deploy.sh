#!/usr/bin/env bash

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}==> 开始极简部署 (非 Nix 模式)${NC}"

# 1. 尝试安装基础软件 (需要 sudo)
install_packages() {
    if command -v apt-get &> /dev/null; then
        sudo apt-get update && sudo apt-get install -y zsh nvim git curl wget fzf ripgrep btop
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y zsh neovim git curl wget fzf ripgrep btop
    elif command -v yum &> /dev/null; then
        sudo yum install -y zsh neovim git curl wget fzf ripgrep btop
    else
        echo -e "${RED}[!] 未找到兼容的包管理器或无 sudo 权限，请手动安装依赖。${NC}"
    fi
}

# 询问是否尝试安装
read -p "是否尝试使用 sudo 安装基础软件? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    install_packages
fi

# 2. 创建配置软链接
echo -e "${BLUE}==> 正在创建配置软链接...${NC}"
CONF_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../config" && pwd)"
TARGET_DIR="$HOME/.config"

mkdir -p "$TARGET_DIR"

# 需要链接的目录列表
configs=("nvim" "btop" "lazygit" "zellij" "zsh" "ohmyposh")

for conf in "${configs[@]}"; do
    if [ -d "$CONF_DIR/$conf" ]; then
        echo -e "链接 $conf -> $TARGET_DIR/$conf"
        rm -rf "$TARGET_DIR/$conf"
        ln -s "$CONF_DIR/$conf" "$TARGET_DIR/$conf"
    fi
done

# 特殊处理 zshrc
echo -e "设置 .zshrc..."
echo "source $TARGET_DIR/zsh/00-init.zsh" > "$HOME/.zshrc"

# 3. 安装工具二进制 (针对无 sudo 用户)
install_user_binaries() {
    mkdir -p "$HOME/.local/bin"
    echo -e "${BLUE}==> 建议手动从 GitHub 下载以下工具的静态二进制版本到 ~/.local/bin:${NC}"
    echo -e "    - eza, bat, zoxide, oh-my-posh, yazi, zellij"
}

install_user_binaries

echo -e "${GREEN}==> 部署完成！${NC}"
echo -e "${BLUE}请手动运行 'chsh -s \$(which zsh)' 切换 shell (如果权限允许)${NC}"
