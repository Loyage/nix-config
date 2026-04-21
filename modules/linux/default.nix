{ mylib
, inputs
, pkgs
, ...
}:
{
  imports = mylib.scanPaths ./.;
  environment.systemPackages = [
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  # thunar file manager(part of xfce) related options
  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-archive-plugin
      thunar-volman
    ];
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc.lib # 解决 libstdc++.so.6 找不到的问题
    zlib # numpy 经常需要
    glib # opencv 需要
    libGL # opencv 图像处理/窗口显示需要
    libX11 # 图形界面支持
  ];
}
