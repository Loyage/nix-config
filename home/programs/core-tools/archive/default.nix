{ pkgs
, mylib
, ...
}: {
  imports = mylib.scanPaths ./.;
  home.packages = with pkgs; [
    zip
    unzip
    xz
    p7zip
    ouch
  ];
}
