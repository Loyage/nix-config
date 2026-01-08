{ pkgs, mylib, ... }:
let
  gui-tools = with pkgs; [
    kitty
    firefox
    rofi
    clash-verge-rev
    waybar
    # zen
  ];
in
{
  home.packages = gui-tools;
  imports = mylib.scanPaths ./.;
}
