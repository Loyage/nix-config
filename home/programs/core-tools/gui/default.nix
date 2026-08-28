{
  pkgs,
  mylib,
  ...
}:
{
  imports = mylib.scanPaths ./.;
  home.packages =
    with pkgs;
    [
      kitty
    ]
    ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
      ghostty
    ];
}
