{ lib, mylib, myvars, ... }: {
  home = {
    inherit (myvars) username;
    homeDirectory = lib.mkForce "/Users/${myvars.username}";
    stateVersion = "25.11";
  };

  programs.home-manager.enable = true;

  imports = (mylib.scanPaths ./.) ++ [
    ../tui-base
    ../gui-base
  ];
}
