{ myvars, ... }: {
  imports = [
    ../terminal
    ./programs
  ];

  home = {
    inherit (myvars) username;
    stateVersion = "25.11";
  };

  programs.home-manager.enable = true;
}
