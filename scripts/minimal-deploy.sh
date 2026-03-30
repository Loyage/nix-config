#!/usr/bin/env bash

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}==> 开始极简部署 (个人用户模式)${NC}"

# 1. 自动选择包管理器
install_manager() {
    echo -e "${BLUE}检测到无 sudo 权限，建议安装个人包管理器:${NC}"
    echo "1) Micromamba (推荐: 快速, 二进制安装, 简单)"
    echo "2) Homebrew (推荐: 包最全, 社区活跃, 源码编译较多)"
    echo "3) 跳过 (手动处理)"
    read -p "请选择 (1/2/3): " choice
    
    case $choice in
        1)
            echo -e "${BLUE}正在安装 Micromamba...${NC}"
            "${SHELL}" <(curl -L micro.mamba.pm/install.sh)
            echo -e "${GREEN}请重新加载 Shell 后运行: micromamba install -c conda-forge neovim git zsh fzf ripgrep eza bat zoxide zellij${NC}"
            ;;
        2)
            echo -e "${BLUE}正在安装 Homebrew 到 ~/.linuxbrew...${NC}"
            git clone https://github.com/Homebrew/brew ~/.linuxbrew/Homebrew
            mkdir -p ~/.linuxbrew/bin
            ln -s ../Homebrew/bin/brew ~/.linuxbrew/bin/
            eval "$(~/.linuxbrew/bin/brew shellenv)"
            echo -e "${GREEN}Homebrew 已安装。建议运行: brew install nvim git zsh fzf ripgrep eza bat zoxide zellij${NC}"
            ;;
        *)
            echo "跳过包管理器安装。"
            ;;
    esac
}

# 如果没有 sudo 权限
if ! sudo -n true 2>/dev/null; then
    install_manager
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

echo -e "${GREEN}==> 配置文件已就位！${NC}"
echo -e "${BLUE}请确保你安装了相应的二进制文件，然后切换到 zsh 即可体验。${NC}"
