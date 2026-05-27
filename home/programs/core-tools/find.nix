{ pkgs
, ...
}: {
  home.packages = with pkgs; [
    which
    fd
    ripgrep
  ];
  # cattpuccin.nix only work when pprograms.xxx is enabled
  programs.fzf.enable = true;
  programs.skim = {
    enable = true;
    enableZshIntegration = true;
  }; # interactive find tool
}
