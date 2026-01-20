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
    wl-clipboard-rs
    cava # Console-based Audio Visualizer for Alsa
    # rofi
    # waybar
    # waypaper
    # swww
  ];
  work-tools = with pkgs; [
    bluetuith
    kitty
    firefox
    clash-verge-rev
    wpsoffice-cn
    typora
    usbutils
  ];
  social-softs = with pkgs; [
    qq
    wechat-uos
    netease-cloud-music-gtk
    obs-studio
    wemeet
    thunderbird
  ];
  other-tools = with pkgs; [
    tree-sitter
  ];
in
{
  home.packages = hypr-tools ++ work-tools ++ social-softs ++ other-tools;

  xdg.configFile =
    let
      mkLink = config.lib.file.mkOutOfStoreSymlink;
      confPath = "${config.home.homeDirectory}/nix-config/config";
    in
    {
      "niri".source = mkLink "${confPath}/niri";
      "noctalia/settings.json".source = mkLink "${confPath}/noctalia/settings.json";
      "qt6ct/qt6ct.conf".source = mkLink "${confPath}/noctalia/qt6ct.conf";
      "hypr/hypridle.conf".source = mkLink "${confPath}/hypr/hypridle.conf";
    };

  imports = mylib.scanPaths ./.;
}
