{ myvars, ... }: {
  imports = [ ../terminal ];

  home = {
    inherit (myvars) username;
    stateVersion = "25.11";
  };

  programs.home-manager.enable = true;
}
