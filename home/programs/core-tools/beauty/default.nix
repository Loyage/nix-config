{ pkgs
, mylib
, ...
}: {
  imports = mylib.scanPaths ./.;
  home.packages = with pkgs; [
    fastfetch
    vivid # generator for LS_COLORS
    chafa # image to ANSI/Unicode character art
  ];
  # cattpuccin.nix only work when pprograms.xxx is enabled
  programs.bat.enable = true;
}
