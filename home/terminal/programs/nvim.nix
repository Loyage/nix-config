{ pkgs, ... }: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  home.packages = with pkgs; [
    stylua
    lua-language-server
    nil
    nixpkgs-fmt
  ];
}
