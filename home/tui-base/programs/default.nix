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
    carapace # shell completion framework
    gnused
    gnutar
    gawk
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
    htop-vim
    lazyssh
    lazyjj
    lazydocker
    lazynpm
  ];

  dev-tools = [ ];
in
{
  home.packages = archives ++ cli-tools ++ ai-tools ++ tui-tools ++ dev-tools;

  programs = {
    fzf.enable = true;
    bat.enable = true;
    lazygit.enable = true;
  };

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
      "nvim".source = mkLink "${confPath}/nvim";
      "avater.png".source = mkLink "${confPath}/avater.png";
      "zsh".source = mkLink "${confPath}/zsh";
    };

  imports = mylib.scanPaths ./.;
}
