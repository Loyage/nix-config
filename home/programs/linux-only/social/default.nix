{ pkgs
, mylib
, ...
}:
{
  imports = mylib.scanPaths ./.;
  home.packages = with pkgs;[
    qq
    wechat
    obs-studio
    thunderbird
  ];
}
