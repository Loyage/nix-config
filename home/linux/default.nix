{ lib, mylib, myvars, inputs, ... }:
{
  home.homeDirectory = lib.mkForce "/home/${myvars.username}";
  imports = (mylib.scanPaths ./.) ++ [
    ../base
    inputs.nix-openclaw.homeManagerModules.openclaw
    inputs.plasma-manager.homeModules.plasma-manager
  ];
}

