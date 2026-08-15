{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    zotero
    wpsoffice-cn
  ];
}
