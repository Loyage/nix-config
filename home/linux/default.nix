{ lib, mylib, myvars, inputs, ... }: {
  home = {
    inherit (myvars) username;
    homeDirectory = lib.mkForce "/home/${myvars.username}";
    stateVersion = "25.11";
  };

  programs.home-manager.enable = true;

  imports = (mylib.scanPaths ./.) ++ [
    ../programs/core-tools
    ../programs/linux-only
    inputs.plasma-manager.homeModules.plasma-manager
  ];
}
