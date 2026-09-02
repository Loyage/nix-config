{
  pkgs,
  mylib,
  config,
  lib,
  hostProfile ? { graphical = true; },
  ...
}:
let
  tools = with pkgs; [
    tree
    tree-sitter
    file
    glow # markdown previewer in terminal
    aria2 # download manager
    socat # socket cat
    fh # flakehub cli
    gomi # rm to trash
    git-crypt # 仓库级文件透明加密（vars/private.nix 等私有数据）
    clash-rs
    gnused
    gnutar
    gawk
  ];
in
{
  # imports 不能依赖普通 module option，因此由 flake 注入的主机能力决定是否导入 GUI 子树。
  imports = builtins.filter (module: hostProfile.graphical || module != ./gui) (mylib.scanPaths ./.);

  home.packages = tools;

  xdg.enable = true;
  xdg.configFile =
    let
      mkLink = config.lib.file.mkOutOfStoreSymlink;
      confPath = "${config.home.homeDirectory}/nix-config/config";
    in
    {
      "nvim".source = mkLink "${confPath}/nvim";
      "bash".source = mkLink "${confPath}/bash";
      "zsh".source = mkLink "${confPath}/zsh";
      "opencode/opencode.jsonc".source = mkLink "${confPath}/opencode/opencode.jsonc";
      "opencode/tui.jsonc".source = mkLink "${confPath}/opencode/tui.jsonc";
      # pi-web-access 配置
      "pi/web-search.json".source = mkLink "${confPath}/pi/web-search.json";
    }
    // lib.optionalAttrs hostProfile.graphical {
      "avater.png".source = mkLink "${confPath}/avater.png";
      "kitty".source = mkLink "${confPath}/kitty";
      "ghostty".source = mkLink "${confPath}/ghostty";
      "zathura".source = mkLink "${confPath}/zathura";
    };
}
