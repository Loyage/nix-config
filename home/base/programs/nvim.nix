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
    lua-language-server
    marksman
  ];
}
