{ inputs
, pkgs
, ...
}:
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  home.packages = with pkgs; [
    pkgs.qt6Packages.qt6ct # for icon theme
    pkgs.app2unit # Launch Desktop Entries (or arbitrary commands) as Systemd user units
    gpu-screen-recorder # recoding screen

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

  home.sessionVariables = {
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_QPA_PLATFORMTHEME = "qt6ct";
    QT_AUTO_SCREEN_SCALE_FACTOR = 1;
  };

  # configure options
  programs.noctalia-shell = {
    enable = true;
    plugins = {
      sources = [
        {
          enabled = true;
          name = "Official Noctalia Plugins ";
          url = " https://github.com/noctalia-dev/noctalia-plugins ";
        }
      ];
      states = {
        catwalk.enabled = true;
        todo.enabled = true;
        kaomoji-provider.enabled = true;
        keybind-cheatsheet.enabled = true;
        fancy-audiovisualizer.enabled = true;
        clipper.enabled = true;
        screen-toolkit.enabled = true;
        niri-animation-picker.enabled = true;
        version = 1;
      };

      pluginSettings = {
        catwalk = {
          minimumThreshold = 25;
          hideBackground = true;
        };
      };
    };
  };
}

