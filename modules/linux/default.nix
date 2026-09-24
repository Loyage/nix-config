{
  mylib,
  inputs,
  pkgs,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;

  # Zen 官方预编译包自带的 ffvpx 只含 vp8/vp9/av1/mp3/flac，不含 H.264 解码器；
  # Firefox 在 Linux 上通过 dlopen 系统 libavcodec 来解码 H.264，因此 wrapper
  # 必须带上 ffmpeg。youwen5/zen-browser-flake 只设置了 passthru.ffmpegSupport，
  # 而当前 nixpkgs 的 wrapFirefox 读取的是 passthru.withFFmpeg，导致 ffmpeg
  # 未被加入 wrapper，H.264 不可用，网站会提示“不支持 HTML5 播放器”。
  zen-browser = pkgs.wrapFirefox (
    inputs.zen-browser.packages.${system}.zen-browser-unwrapped
    // {
      withFFmpeg = true;
    }
  ) { pname = "zen-browser"; };
in
{
  imports = mylib.scanPaths ./.;
  environment.systemPackages = [
    zen-browser
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
