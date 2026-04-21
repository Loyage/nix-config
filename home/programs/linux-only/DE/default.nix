{ pkgs
, config
, mylib
, ...
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
      confPath = "${config.home.homeDirectory}/nix-config/config";
    in
    {
      "hypr".source = mkLink "${confPath}/hypr";
      "niri".source = mkLink "${confPath}/niri";
      "noctalia/settings.json".source = mkLink "${confPath}/noctalia/settings.json";
      "qt6ct/qt6ct.conf".source = mkLink "${confPath}/noctalia/qt6ct.conf";
    };

  # 默认浏览器设置为 Zen Browser（影响 xdg-open 等）
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "zen.desktop";
      "x-scheme-handler/http" = "zen.desktop";
      "x-scheme-handler/https" = "zen.desktop";
      "x-scheme-handler/about" = "zen.desktop";
      "x-scheme-handler/unknown" = "zen.desktop";
    };
  };

  imports = mylib.scanPaths ./.;
}
