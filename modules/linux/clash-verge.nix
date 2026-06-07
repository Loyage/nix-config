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

  # networking.firewall.trustedInterfaces = [ "Mihomo" "Meta" ];

  # boot.kernel.sysctl = {
  #   "net.ipv4.ip_forward" = 1;
  #   "net.ipv6.conf.all.forwarding" = 1;
  # };
}
