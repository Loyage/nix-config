{
  mylib,
  inputs,
  pkgs,
  ...
}:
{
  imports = mylib.scanPaths ./.;
  environment.systemPackages = [
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  programs.steam = {
    enable = true;
    # 默认不因安装 Steam 而开放入站端口。确有需要时在 hosts/local/ 按主机覆盖。
    remotePlay.openFirewall = false;
    dedicatedServer.openFirewall = false;
    localNetworkGameTransfers.openFirewall = false;
  };

  # thunar file manager(part of xfce) related options
  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-archive-plugin
      thunar-volman
    ];
  };
}
