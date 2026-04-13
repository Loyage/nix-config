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
    hardinfo2
    lx-music-desktop
    # rofi
    # waybar
    # waypaper
    # swww

    # used by noctalia screen toolkit plugin
    grim # screenshot cli tool
    slurp # select region for screenshot or wf-recorder
    wl-clipboard-rs # wayland clipboard tool
    # tesseract # OCR tool for screen toolkit plugin
    (tesseract.override {
      enableLanguages = [ "chi_sim" "eng" ];
    })
    imagemagick # for image processing
    zbar # for QR code scanning
    translate-shell # for translation
    wf-recorder # for screen recording
    ffmpeg # for video processing
    gifski # for creating gifs
  ];
  work-tools = with pkgs; [
    bluetuith
    firefox
    chromium
    kitty
    clash-verge-rev
    wpsoffice-cn
    typora
    usbutils
    zotero
    conda
  ];
  social-softs = with pkgs; [
    qq
    wechat
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
    nix-output-monitor # monitor nix build output in real time
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
