{ pkgs
, mylib
, ...
}:
{
  imports = mylib.scanPaths ./.;
  home.packages = with pkgs; [
    kitty
    firefox
    zotero
    hardinfo2
    bluetuith
    usbutils
  ];
}
