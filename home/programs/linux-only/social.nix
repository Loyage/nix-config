{ pkgs
, ...
}:
{
  home.packages = with pkgs;[
    qq
    wechat
    obs-studio
    thunderbird
  ];
}
