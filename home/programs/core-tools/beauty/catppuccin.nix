{ inputs
, ...
}: {
  imports = [
    inputs.catppuccin.homeModules.catppuccin
  ];
  catppuccin = {
    enable = true;
    # one of "latte", "frappe", "macchiato", "mocha"
    flavor = "frappe";
    # one of "blue", "flamingo", "green", "lavender", "maroon", "mauve", "peach", "pink", "red", "rosewater", "sapphire", "sky", "teal", "yellow"
    accent = "sapphire";

    # Disable for using softlinks
    nvim.enable = false;
    fcitx5.enable = false;
  };
}
