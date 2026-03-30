{ ... }: {
  xdg.enable = true;

  imports = [
    ./git.nix
    ./programs
  ];
}
