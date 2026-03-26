{ pkgs
, lib
, config
, ...
}:
let
  extra-cli = with pkgs; [
    cargo
    aria2    # download manager
    socat    # socket cat
    nmap     # network exploration tool
    gh       # github cli
    github-copilot-cli
    fh       # flakehub cli
    chafa    # image to ANSI/Unicode character art
    gomi     # rm to trash
    vivid    # generator for LS_COLORS
    statix   # lints and suggestions for nix
    clash-meta
  ];

  ai-tools = with pkgs; [
    opencode
    claude-code
    codex
    gemini-cli
  ];

  extra-tui = with pkgs; [
    lazyssh
    lazyjj
    lazydocker
    lazynpm
  ];

  extra-dev = with pkgs; [
    neovide
  ];

  gui-tools = with pkgs; [
    zathura
  ];
in
{
  home.packages = extra-cli ++ ai-tools ++ extra-tui ++ extra-dev ++ gui-tools;

  xdg.configFile =
    let
      mkLink = config.lib.file.mkOutOfStoreSymlink;
      confPath = "${config.home.homeDirectory}/nix-config/config";
    in
    {
      "avater.png".source = mkLink "${confPath}/avater.png";
      "kitty".source = mkLink "${confPath}/kitty";
      "zathura".source = mkLink "${confPath}/zathura";
    };
}
