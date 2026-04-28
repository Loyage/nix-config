{ pkgs
, ...
}: {
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
    nixpkgs-fmt
  ];

  # 手动设置默认编辑器环境变量
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
}
