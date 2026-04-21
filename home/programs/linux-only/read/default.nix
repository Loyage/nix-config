{ pkgs
, mylib
, ...
}:
{
  imports = mylib.scanPaths ./.;
  home.packages = with pkgs; [
    neovide
    zathura
    typora
  ];
}
