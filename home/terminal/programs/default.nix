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
    autojump
    zoxide
    which
    fastfetch
    tree
    ripgrep
    file
    glow # markdown previewer in terminal
    dust # find large files
    duf # disk usage
    python3
    uv # python package manager
    carapace # shell completion framework
    gnused
    gnutar
    gawk
    cargo
    aria2 # download manager
    socat # socket cat
    nmap # network exploration tool
    gh # github cli
    fh # flakehub cli
    chafa # image to ANSI/Unicode character art
    gomi # rm to trash
    vivid # generator for LS_COLORS
    statix # lints and suggestions for nix
  ];

  ai-tools = with pkgs; [
    opencode
    claude-code
    codex
    gemini-cli
  ];

  tui-tools = with pkgs; [
    lazygit
    htop-vim
    lazyssh
    lazyjj
    lazydocker
    lazynpm
  ];

  dev-tools = with pkgs; [
    lua
    luarocks
    cmake
    (lib.lowPrio nodejs)
  ];
in
{
  home.packages = archives ++ cli-tools ++ ai-tools ++ tui-tools ++ dev-tools;

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
      "lazygit".source = mkLink "${confPath}/lazygit";
      "nvim".source = mkLink "${confPath}/nvim";
      "zsh".source = mkLink "${confPath}/zsh";
    };

  imports = mylib.scanPaths ./.;
}
