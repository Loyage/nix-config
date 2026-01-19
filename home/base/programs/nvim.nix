{ config
, pkgs
, ...
}:
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
    stylua
    lua-language-server
    marksman
  ];
}
