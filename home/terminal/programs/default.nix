{ pkgs
, lib
, mylib
, config
, ...
}:
let
  archives = with pkgs; [
    zip
    unzip
    xz
    p7zip
    ouch
  ];

  cli-tools = with pkgs; [
    bat
    btop
    autojump
    zoxide
    which
    fastfetch
    tree
    fzf
    ripgrep
    file
    glow     # markdown previewer in terminal
    dust     # find large files
    duf      # disk usage
    python3
    uv       # python package manager
    carapace # shell completion framework
    zellij   # terminal multiplexer
    gnused
    gnutar
    gawk
  ];

  tui-tools = with pkgs; [
    lazygit
    htop-vim
  ];

  dev-tools = with pkgs; [
    lua
    luarocks
    cmake
    (lib.lowPrio nodejs)
  ];
in
{
  home.packages = archives ++ cli-tools ++ tui-tools ++ dev-tools;

  programs.skim = {
    enable = true;
    enableZshIntegration = true;
  };

  xdg.configFile =
    let
      mkLink = config.lib.file.mkOutOfStoreSymlink;
      confPath = "${config.home.homeDirectory}/nix-config/config";
    in
    {
      "btop".source = mkLink "${confPath}/btop";
      "lazygit".source = mkLink "${confPath}/lazygit";
      "nvim".source = mkLink "${confPath}/nvim";
      "zellij".source = mkLink "${confPath}/zellij";
      "zsh".source = mkLink "${confPath}/zsh";
    };

  imports = mylib.scanPaths ./.;
}
