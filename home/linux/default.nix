{ lib, mylib, myvars, inputs, ... }: {
  home = {
    inherit (myvars) username;
    homeDirectory = lib.mkForce "/home/${myvars.username}";
    stateVersion = "25.11";
  };

  programs.home-manager.enable = true;

  imports = (mylib.scanPaths ./.) ++ [
    ../tui-base
    ../gui-base
    inputs.nix-openclaw.homeManagerModules.openclaw
    inputs.plasma-manager.homeModules.plasma-manager
  ];
}
