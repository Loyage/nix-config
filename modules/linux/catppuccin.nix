{ inputs
, ...
}: {
  imports = [ inputs.catppuccin.nixosModules.catppuccin ];
  catppuccin = {
    enable = true;
    # one of "latte", "frappe", "macchiato", "mocha"
    flavor = "frappe";
    # one of "blue", "flamingo", "green", "lavender", "maroon", "mauve", "peach", "pink", "red", "rosewater", "sapphire", "sky", "teal", "yellow"
    accent = "sapphire";

    fcitx5.enable = false;
  };
}
