{ pkgs
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
    cargo
    bat
    btop # resource monitor
    autojump
    zoxide
    which
    oh-my-posh
    fastfetch
    tree
    fzf # fuzzy finder
    ripgrep # rg
    aria2 # download manager
    socat # socket cat
    nmap # network exploration tool
    file # file type detection
    gh # git hub cli
    gh-copilot
    fh # flakehub cli
    glow # markdown previewer in terminal
    chafa # image to ANSI/Unicode character art
    gomi # rm to trash
    dust # find the large occupied file
    duf # disk usage
    vivid # Generator for LS_COLORS
    statix # Lints and suggestions for nix
    yadm # Yet Another Dotfiles Manager
    python3
    zellij # terminal multiplexer
    gnused # sed: stream editor, use a script to perform basic text transformations on an input stream (a file or input from a pipeline)
    gnutar # tar
    gawk # awk: a programming language that is designed for text processing and typically used as a data extraction and reporting tool
  ];

  ai-tools = with pkgs; [
    opencode
    claude-code
    codex
    gemini-cli
  ];

  tui-tools = with pkgs; [
    lazygit
    lazyssh
    lazyjj
    lazydocker
    lazynpm
    htop-vim # htop with vim keybindings
  ];

  dev-tools = with pkgs; [
    neovide
    lua
    luarocks
    cmake
    nodejs
    carapace
    uv
    clash-meta
  ];

  gui-tools = with pkgs; [
    zathura
  ];
in
{
  home.packages = archives ++ cli-tools ++ ai-tools ++ tui-tools ++ dev-tools ++ gui-tools;

  programs = {

    # skim provides a single executable: sk.
    # Basically anywhere you would want to use grep, try sk instead.
    skim = {
      enable = true;
      enableZshIntegration = true;
    };
  };
  xdg.configFile =
    let
      mkLink = config.lib.file.mkOutOfStoreSymlink;
      confPath = "${config.home.homeDirectory}/nix-config/config";
    in
    {
      "avater.png".source = mkLink "${confPath}/avater.png";
      "btop".source = mkLink "${confPath}/btop";
      "kitty".source = mkLink "${confPath}/kitty";
      "lazygit".source = mkLink "${confPath}/lazygit";
      "nvim".source = mkLink "${confPath}/nvim";
      "zathura".source = mkLink "${confPath}/zathura";
      "zellij".source = mkLink "${confPath}/zellij";
      "zsh".source = mkLink "${confPath}/zsh";
    };

  imports = mylib.scanPaths ./.;
}
