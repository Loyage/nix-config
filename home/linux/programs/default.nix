{ pkgs, mylib, ... }:
let
  hypr-tools = with pkgs; [
    hyprpicker # color picker
    hyprshot # screen shot
    wf-recorder # screen recording
    kitty
    rofi
    # waybar
    # waypaper
    wl-clipboard-rs
    swww
    firefox
    bluetuith
    clash-verge-rev
  ];
  work-tools = with pkgs; [
    wpsoffice-cn
    usbutils
  ];
  social-softs = with pkgs; [
    qq
    wechat-uos
    netease-cloud-music-gtk
    obs-studio
    wemeet
  ];
  other-tools = with pkgs; [
    tree-sitter
  ];
in
{
  home.packages = hypr-tools ++ work-tools ++ social-softs ++ other-tools;
  imports = mylib.scanPaths ./.;
}
