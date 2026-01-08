{ lib, mylib, myvars, ... }:
let
  tools = with pkgs; [
    sketchybar
  ] ;
in 
{
  home.homeDirectory = lib.mkForce "/Users/${myvars.username}";
  imports = (mylib.scanPaths ./.) ++ [ ../base ];
}

