{
  pkgs,
  mylib,
  ...
}:
{
  imports = mylib.scanPaths ./.;
  home.packages = with pkgs; [
    # firefox
    # chromium
    hardinfo2
    bluetuith
    usbutils
  ];
}
