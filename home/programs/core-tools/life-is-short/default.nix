{ pkgs
, mylib
, ...
}: {
  imports = mylib.scanPaths ./.;
  home.packages = with pkgs; [
    just
    autojump
    zoxide
    carapace # shell completion framework
  ];
}
