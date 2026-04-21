{ lib
, myvars
, ...
}: {
  home = {
    inherit (myvars) username;
    homeDirectory = lib.mkForce "/home/${myvars.username}";
    stateVersion = "25.11";
  };

  programs.home-manager.enable = true;
}
