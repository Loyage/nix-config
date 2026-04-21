{ pkgs
, mylib
, ...
}: {
  imports = mylib.scanPaths ./.;
  home.packages = with pkgs; [
    htop-vim
    dust # find large files
    duf # disk usage
    nmap # network exploration tool
  ];
}
