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
    xdg-desktop-portal-hyprland # 解决wemeet niri/hyprland下共享屏幕问题
    thunderbird

    ## for game
    wine
    lutris
    protonplus
  ];
  other-tools = with pkgs; [
    tree-sitter
    fzf # fuzzy finder for session selector
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
      "hypr".source = mkLink "${confPath}/hypr";
      "niri".source = mkLink "${confPath}/niri";
      "noctalia/settings.json".source = mkLink "${confPath}/noctalia/settings.json";
      "qt6ct/qt6ct.conf".source = mkLink "${confPath}/noctalia/qt6ct.conf";
    };

  imports = mylib.scanPaths ./.;
}
