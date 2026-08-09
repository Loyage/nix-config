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
  programs.noctalia = {
    enable = true;
    settings = {
      location.auto_locate = true;
      shell = {
        password_style = "random";
        avatar_path = "/home/loyage/nix-config/config/avater.png";
        lang = "zh-Hans";
        font_family = "Maple Mono NF CN";
        panel.launcher_position = "bottom_center";
        screen_corners = {
          enabled = true;
          size = 40;
        };
        panel = {
          session_position = "center";
          transparency_mode = "soft";
        };
      };
      wallpaper = {
        automation.enabled = true;
        transition_on_startup = true;
      };
      theme = {
        builtin = "Catppuccin";
        mode = "auto";
        source = "wallpaper";
      };
      idle = {
        pre_action_fade_seconds = 5;
        behavior = {
          lock = {
            action = "lock";
            enabled = true;
            timeout = 600.0;
          };
          lock-and-suspend = {
            action = "lock_and_suspend";
            enabled = false;
            timeout = 900.0;
          };
          screen-off = {
            action = "screen_off";
            enabled = true;
            timeout = 660.0;
          };
        };
      };
      shell.session.actions = [
        {
          action = "lock";
          shortcut = "1";
        }
        {
          action = "command";
          label = "黑屏";
          glyph = "screen-share-off";
          command = "noctalia msg dpms-off";
          shortcut = "2";
        }
        {
          action = "logout";
          shortcut = "3";
        }
        # {
        #   action = "lock_and_suspend";
        #   countdown_seconds = 0.0;
        # }
        {
          action = "reboot";
          countdown_seconds = 10.0;
          shortcut = "4";
        }
        {
          action = "shutdown";
          countdown_seconds = 10.0;
          shortcut = "5";
          variant = "destructive";
        }
        {
          action = "command";
          label = "休眠";
          glyph = "hibernate";
          command = "sudo systemctl hibernate";
          countdown_seconds = 10.0;
          shortcut = "6";
          variant = "destructive";
        }
      ];
      dock = {
        enabled = true;
        reserve_space = false;
        smart_auto_hide = true;
        icon_size = 36;
        launcher_position = "start";
      };
      bar.order = [ "mybar" ];
      bar.mybar = {
        thickness = 40;
        background_opacity = 0.4;
        start = [
          "launcher"
          "wallpaper"
          "nix-monitor"
          "workspaces"
          "group:g1"
        ];
        center = [
          "clock"
          "caffeine"
          "screen-toolkit"
        ];
        end = [
          "media"
          "tray"
          "notifications"
          "clipboard"
          "network"
          "bluetooth"
          "volume"
          "brightness"
          "battery"
          "session"
        ];
        capsule_group = [
          {
            id = "g1";
            enabled = true;
            fill = "surface_variant";
            members = [ "cpu" "ram" "temp" ];
            opacity = 0.4;
            padding = 6.0;
          }
        ];
      };
      plugins = {
        auto_update = false;
        enabled = [ "avivbintangaringga/nix-monitor" "alexander/screen-toolkit" ];
        source = [
          {
            kind = "git";
            location = "https://github.com/noctalia-dev/official-plugins";
            name = "official";
          }
          {
            kind = "git";
            location = "https://github.com/noctalia-dev/community-plugins";
            name = "community";
          }
        ];
      };
      widget = {
        nix-monitor = {
          show_text = false;
          type = "avivbintangaringga/nix-monitor:nix-monitor";
        };
        media = {
          hide_when_no_media = true;
        };
        notifications = {
          hide_when_no_unread = true;
        };
        screen-toolkit = {
          type = "alexander/screen-toolkit:widget";
        };
      };
      #     plugins = {
      #       sources = [
      #         {
      #           enabled = true;
      #           name = "Official Noctalia Plugins ";
      #           url = " https://github.com/noctalia-dev/noctalia-plugins ";
      #         }
      #       ];
      #       states = {
      #         catwalk.enabled = true;
      #         todo.enabled = true;
      #         kaomoji-provider.enabled = true;
      #         keybind-cheatsheet.enabled = true;
      #         fancy-audiovisualizer.enabled = true;
      #         clipper.enabled = true;
      #         screen-toolkit.enabled = true;
      #         niri-animation-picker.enabled = true;
      #         version = 1;
      #       };
      #
      #       pluginSettings = {
      #         catwalk = {
      #           minimumThreshold = 25;
      #           hideBackground = true;
      #         };
      #       };
      #     };
    };
  };
}
