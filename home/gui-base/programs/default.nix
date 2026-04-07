{ pkgs
, config
, mylib
, ...
}:
let
  gui-tools = with pkgs; [
    neovide
    zathura
  ];
in
{
  imports = mylib.scanPaths ./.;

  home.packages = gui-tools;

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
