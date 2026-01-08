{ pkgs, mylib, ... }:
let
  archives = with pkgs; [
    zip
    xz
    unzip
    p7zip
    ouch
  ];

  cli-tools = with pkgs; [
    bat
    autojump
    zoxide
    which
    oh-my-posh
    fastfetch
    tealdeer # tldr client
    fzf # fuzzy finder
    ripgrep # rg
    aria2 # download manager
    socat # socket cat
    nmap # network exploration tool
    file # file type detection
    gh # git hub cli
    fh # flakehub cli
    zellij # terminal workspace
    glow # markdown previewer in terminal
    chafa # image to ANSI/Unicode character art
    gomi # rm to trash
    dust # find the large occupied file
    duf # disk usage
    vivid # Generator for LS_COLORS
    statix # Lints and suggestions for nix
    yadm # Yet Another Dotfiles Manager

    gnused # sed: stream editor, use a script to perform basic text transformations on an input stream (a file or input from a pipeline)
    gnutar # tar
    gawk # awk: a programming language that is designed for text processing and typically used as a data extraction and reporting tool
  ];

  tui-tools = with pkgs; [
    lazygit
    lazyssh
    lazyjj
    lazydocker
    lazynpm
    htop-vim # htop with vim keybindings
    btop # resource monitor
  ];

  dev-tools = with pkgs; [
    neovide
    gnupg
    lua
    luarocks
    cmake
    nodejs
    carapace
    jujutsu
    uv
    sketchybar
    clash-meta
  ];

  gui-tools = with pkgs; [
    zathura
  ];
in
{
  home.packages = archives ++ cli-tools ++ tui-tools ++ dev-tools ++ gui-tools;

  programs = {
    # modern vim
    neovim = {
      enable = true;
      defaultEditor = true;
    };

    # skim provides a single executable: sk.
    # Basically anywhere you would want to use grep, try sk instead.
    skim = {
      enable = true;
      enableZshIntegration = true;
    };
  };

  imports = mylib.scanPaths ./.;
}
