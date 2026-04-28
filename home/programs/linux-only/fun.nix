{ pkgs
, ...
}:
{
  home.packages = with pkgs;[
    # music
    netease-cloud-music-gtk
    lx-music-desktop

    # game
    wine
    # lutris
    protonplus
  ];
}
