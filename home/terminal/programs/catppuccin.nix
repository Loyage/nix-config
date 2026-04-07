_: {
  catppuccin = {
    enable = true;
    flavor = "frappe";
    accent = "sapphire";

    # Disable for using softlinks
    lazygit.enable = false;
    nvim.enable = false;

    fcitx5.enableRounded = true;
  };

  programs.bat.enable = true;
  programs.fzf.enable = true;
}
