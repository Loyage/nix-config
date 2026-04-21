{ pkgs
, mylib
, ...
}:
{
  imports = mylib.scanPaths ./.;
  home.packages = with pkgs; [
    kitty
    clash-verge-rev
    firefox
    zotero
    hardinfo2
    bluetuith
    usbutils
  ];
}
