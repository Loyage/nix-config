{ pkgs
, mylib
, ...
}: {
  imports = mylib.scanPaths ./.;
  home.packages = with pkgs; [
    typora
    helix
  ];
}
