{ lib, mylib, myvars, ... }:
{
  home.homeDirectory = lib.mkForce "/Users/${myvars.username}";
  imports = (mylib.scanPaths ./.) ++ [ ../base ];
}

