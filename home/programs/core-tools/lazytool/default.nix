{ pkgs
, mylib
, ...
}: {
  imports = mylib.scanPaths ./.;
  home.packages = with pkgs; [
    lazyssh
    lazyjj
    lazydocker
    lazynpm
  ];
  # cattpuccin.nix only work when pprograms.xxx is enabled
  programs.lazygit.enable = true;
}
