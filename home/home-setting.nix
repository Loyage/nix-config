{ pkgs
, myvars
, ...
}: {
  home = {
    inherit (myvars) username;
    homeDirectory = if pkgs.stdenv.isDarwin then "/Users/loyage" else "/home/loyage";
    stateVersion = "25.11";
  };

  programs.home-manager.enable = true;
}
