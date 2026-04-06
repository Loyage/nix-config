{ ... }: {
  catppuccin.enable = true;
  catppuccin.flavor = "mocha";
  catppuccin.accent = "blue";

  # Disable catppuccin for programs that have custom/symlinked themes to avoid conflicts
  catppuccin.lazygit.enable = false;
  catppuccin.nvim.enable = false;
  catppuccin.yazi.enable = false;

  programs.bat.enable = true;
  programs.fzf.enable = true;
}
