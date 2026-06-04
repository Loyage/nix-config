{ pkgs
, ...
}:
{
  home.packages = with pkgs; [
    neovide
    zathura
    typora
  ];
}
