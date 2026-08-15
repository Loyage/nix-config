{
  pkgs,
  mylib,
  ...
}:
{
  imports = mylib.scanPaths ./.;
  home.packages = with pkgs; [
    kitty
  ];
}
