{ inputs, ... }: {
  imports = [ inputs.catppuccin.nixosModules.catppuccin ];
  catppuccin = {
    enable = true;
    flavor = "frappe";
    accent = "sapphire";

    fcitx5.enable = false;
  };
}
