{ lib, mylib, myvars, ... }:
{
  home.homeDirectory = lib.mkForce "/home/${myvars.username}";
  imports = (mylib.scanPaths ./.) ++ [ ../base ];
}

