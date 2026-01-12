{ config
, pkgs
, ...
}:
let
  # modern vim
  program = "nvim";
in
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    # plugins = with pkgs.vimPlugins; [
    #   nvim-treesitter.withAllGrammars
    #   lazy-nvim
    # ];
  };

  home.packages = with pkgs; [
    lua-language-server
  ];
}
