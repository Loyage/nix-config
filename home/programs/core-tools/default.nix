{ pkgs
, mylib
, config
, ...
}:
let
  tools = with pkgs; [
    tree
    tree-sitter
    file
    glow # markdown previewer in terminal
    aria2 # download manager
    socat # socket cat
    gh # github cli
    fh # flakehub cli
    gomi # rm to trash
    statix # lints and suggestions for nix
    nix-output-monitor # monitor nix build output in real time
    clash-rs
    gnused
    gnutar
    gawk
  ];
in
{
  imports = mylib.scanPaths ./.;

  home.packages = tools;

  xdg.enable = true;
  xdg.configFile =
    let
      mkLink = config.lib.file.mkOutOfStoreSymlink;
      confPath = "${config.home.homeDirectory}/nix-config/config";
    in
    {
      "nvim".source = mkLink "${confPath}/nvim";
      "avater.png".source = mkLink "${confPath}/avater.png";
      "zsh".source = mkLink "${confPath}/zsh";
      "kitty".source = mkLink "${confPath}/kitty";
      "zathura".source = mkLink "${confPath}/zathura";
    };
}
