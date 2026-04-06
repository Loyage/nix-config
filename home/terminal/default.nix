{ inputs, ... }: {
  xdg.enable = true;

  imports = [
    ./git.nix
    ./programs
    inputs.catppuccin.homeManagerModules.catppuccin
  ];
}
