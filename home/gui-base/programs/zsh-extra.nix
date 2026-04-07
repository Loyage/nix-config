{ ... }: {
  # 桌面环境额外 oh-my-zsh 插件（在 tui-base/programs/zsh.nix 的基础上追加）
  programs.zsh.oh-my-zsh.plugins = [
    "brew"
    "conda"
    "archlinux"
  ];
}
