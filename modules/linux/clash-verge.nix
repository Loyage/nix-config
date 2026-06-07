{ pkgs
, myvars
, ...
}:
{
  boot.kernelModules = [ "tun" ];

  programs.clash-verge = {
    enable = true;
    package = pkgs.clash-verge-rev;
    serviceMode = true;
    tunMode = true;
    group = myvars.username;
  };
}
