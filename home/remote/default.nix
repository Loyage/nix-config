{ myvars, lib, ... }: {
  home = {
    username = lib.mkDefault myvars.username;
    homeDirectory = lib.mkDefault "/home/${myvars.username}";
    stateVersion = "25.11";
  };

  programs.home-manager.enable = true;

  imports = [
    ../programs/core-tools
  ];
}
