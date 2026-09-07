{
  pkgs,
  ...
}:
{
  home.packages =
    with pkgs;
    pkgs.lib.optionals pkgs.stdenv.hostPlatform.isLinux [
      wpsoffice-cn
      zotero
    ];
}
