{
  lib,
  pkgs,
  config,
  mylib,
  myvars,
  ...
}:
let
  hypr-tools = with pkgs; [
    hyprpicker # color picker
    hyprshot # screen shot
    wf-recorder # screen recording
    papirus-icon-theme
    wl-mirror
    cava # Console-based Audio Visualizer for Alsa
    # rofi
    # waybar
    # waypaper
    # swww
  ];
in
{
  home.packages = hypr-tools;

  xdg.configFile =
    let
      mkLink = config.lib.file.mkOutOfStoreSymlink;
      confPath = "${config.home.homeDirectory}/${myvars.repositoryDirectory}/config";
    in
    {
      "niri".source = mkLink "${confPath}/niri";
      "xdg-desktop-portal-termfilechooser/config".text = ''
        [filechooser]
        env=TERMCMD='${lib.getExe pkgs.ghostty}'
        cmd='${pkgs.xdg-desktop-portal-termfilechooser}/share/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh'
        default_dir=$HOME/Downloads
        open_mode=suggested
        save_mode=last
      '';
    };

  # 默认浏览器设置为 Zen Browser（影响 xdg-open 等）
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "zen.desktop";
      "inode/directory" = "yazi.desktop";
      "x-scheme-handler/http" = "zen.desktop";
      "x-scheme-handler/https" = "zen.desktop";
      "x-scheme-handler/about" = "zen.desktop";
      "x-scheme-handler/unknown" = "zen.desktop";
    };
  };

  imports = mylib.scanPaths ./.;
}
