{ lib, mylib, myvars, pkgs, ... }:
let
  tools = with pkgs; [
    sketchybar
  ];
in
{
  home.homeDirectory = lib.mkForce "/Users/${myvars.username}";
  imports = (mylib.scanPaths ./.) ++ [ ../base ];
}

