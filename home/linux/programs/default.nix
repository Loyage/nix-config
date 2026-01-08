{ pkgs, mylib, ... }:
let
  gui-tools = with pkgs; [
    kitty
    firefox
    # zen
  ];
in
{
  home.packages = gui-tools;
  imports = mylib.scanPaths ./.;
}
