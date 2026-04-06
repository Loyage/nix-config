{ inputs, ... }: {
  imports = [ inputs.catppuccin.darwinModules.catppuccin ];
  catppuccin.enable = true;
  catppuccin.flavor = "frappe";
}
