{
  pkgs,
  ...
}:
{
  # 禁用 Home Manager 的 Neovim 模块以避免配置文件冲突
  programs.neovim.enable = false;

  home.packages = with pkgs; [
    # 手动安装 Neovim 并配置 provider
    (neovim.override {
      withRuby = false;
      withPython3 = true;
    })

    # 相关工具
    stylua
    lua-language-server
    nil
    # 与 pre-commit hook 同款 formatter（nixfmt == nixfmt-rfc-style）
    nixfmt
  ];

  # 手动设置默认编辑器环境变量
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
}
