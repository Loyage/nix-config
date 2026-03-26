{ pkgs
, lib
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
    oh-my-posh
    fastfetch
    tree
    fzf
    ripgrep
    file
    glow     # markdown previewer in terminal
    dust     # find large files
    duf      # disk usage
    gnused
    gnutar
    gawk
    python3
    uv       # python package manager
    carapace # shell completion framework
    zellij   # terminal multiplexer
  ];

  tui-tools = with pkgs; [
    lazygit
    htop-vim
  ];

  dev-tools = with pkgs; [
    lua
    luarocks
    cmake
    stylua
    lua-language-server
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

  imports = [
    ../../base/programs/eza.nix
    ../../base/programs/ohmyposh.nix
    ../../base/programs/tealdeer.nix
    ./nvim.nix
    ./yazi.nix
    ./zsh.nix
  ];
}
