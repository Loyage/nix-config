{ pkgs, ... }:
{
  # GTK 主题（通过 Home Manager gtk 模块）
  gtk = {
    enable = true;
    theme = {
      name = "WhiteSur-dark";
      package = pkgs.whitesur-gtk-theme;
    };
    iconTheme = {
      name = "WhiteSur-dark";
      package = pkgs.whitesur-icon-theme;
    };
    cursorTheme = {
      name = "WhiteSur-cursors";
      package = pkgs.whitesur-cursors;
      size = 24;
    };
  };

  programs.plasma = {
    enable = true;

    # ── 全局外观 ──────────────────────────────────────────────────────────────
    workspace = {
      lookAndFeel = "com.github.vinceliuice.WhiteSur-dark";
      colorScheme = "WhiteSurDark";
      iconTheme = "WhiteSur-dark";
      widgetStyle = "kvantum-dark";
      cursor = {
        theme = "WhiteSur-cursors";
        size = 24;
      };
      # 壁纸幻灯片（目录需存在，否则使用默认壁纸）
      wallpaperSlideShow = {
        path = "/home/loyage/Pictures/Wallpapers";
        interval = 1800;
      };
    };

    # ── KWin 窗口管理器 ────────────────────────────────────────────────────────
    kwin = {
      effects = {
        translucency.enable = true;
        wobblyWindows.enable = true;
      };
      virtualDesktops = {
        number = 4;
        rows = 1;
      };
    };

    # ── 任务栏 ─────────────────────────────────────────────────────────────────
    panels = [
      {
        location = "bottom";
        floating = true;
        height = 44;
        lengthMode = "fit";
        hiding = "autohide";
        opacity = "adaptive";
        widgets = [
          "org.kde.plasma.kickoff"
          "org.kde.plasma.pager"
          "org.kde.plasma.icontasks"
          "org.kde.plasma.marginsseparator"
          {
            systemTray.items = {
              shown = [
                "org.kde.plasma.battery"
                "org.kde.plasma.brightness"
                "org.kde.plasma.volume"
                "org.kde.plasma.networkmanagement"
                "org.kde.plasma.bluetooth"
              ];
              hidden = [
                "org.kde.plasma.clipboard"
                "org.kde.plasma.cameraindicator"
                "org.kde.plasma.manage-inputmethod"
                "org.kde.kdeconnect"
                "org.kde.plasma.keyboardlayout"
                "org.kde.plasma.devicenotifier"
                "org.kde.plasma.notifications"
                "org.kde.kscreen"
                "org.kde.plasma.keyboardindicator"
                "org.kde.plasma.networkmanagement"
                "org.kde.plasma.printmanager"
                "org.kde.plasma.weather"
              ];
            };
          }
          {
            digitalClock = {
              calendar.firstDayOfWeek = "monday";
            };
          }
          "org.kde.plasma.showdesktop"
        ];
      }
    ];

    # ── 输入设备 ────────────────────────────────────────────────────────────────
    input = {
      touchpads = [
        {
          enable = true;
          name = "Synaptics TM3471-010";
          vendorId = "1739";
          productId = "0";
          naturalScroll = true;
          # ClickMethod=2 = 双指点击为右键
          rightClickMethod = "twoFingers";
          scrollSpeed = 5;
        }
      ];
      mice = [
        {
          name = "TPPS/2 Elan TrackPoint";
          vendorId = "2";
          productId = "10";
          naturalScroll = true;
        }
      ];
      keyboard.numlockOnStartup = "on";
    };

    # ── KRunner ────────────────────────────────────────────────────────────────
    krunner = {
      position = "center";
      historyBehavior = "disabled";
    };

    # ── 全局快捷键 ─────────────────────────────────────────────────────────────
    shortcuts = {
      kwin = {
        "Window Close" = "Meta+Q";
        "Switch Window Down" = "Meta+J";
        "Switch Window Up" = "Meta+K";
        "Switch Window Left" = "Meta+H";
        "Switch Window Right" = "Meta+L";
        "Window Quick Tile Bottom" = "Meta+Ctrl+J";
        "Window Quick Tile Top" = "Meta+Ctrl+K";
        "Window Quick Tile Left" = "Meta+Ctrl+H";
        "Window Quick Tile Right" = "Meta+Ctrl+L";
        "Window Maximize" = "Meta+F";
        "Window Fullscreen" = "Meta+Shift+F";
        "Window On All Desktops" = "Meta+T";
        "Switch to Desktop 1" = "Meta+1";
        "Switch to Desktop 2" = "Meta+2";
        "Switch to Desktop 3" = "Meta+3";
        "Switch to Desktop 4" = "Meta+4";
        "Switch to Desktop 5" = "Meta+5";
        "Switch to Desktop 6" = "Meta+6";
        "Switch to Desktop 7" = "Meta+7";
        "Switch to Desktop 8" = "Meta+8";
        "Switch to Desktop 9" = "Meta+9";
        "Window to Desktop 1" = "Meta+Shift+1";
        "Window to Desktop 2" = "Meta+Shift+2";
        "Window to Desktop 3" = "Meta+Shift+3";
        "Window to Desktop 4" = "Meta+Shift+4";
        "Window to Desktop 5" = "Meta+Shift+5";
        "Window to Desktop 6" = "Meta+Shift+6";
        "Window to Desktop 7" = "Meta+Shift+7";
        "Window to Desktop 8" = "Meta+Shift+8";
        "Window to Desktop 9" = "Meta+Shift+9";
        "Switch One Desktop Down" = [ "Meta+Page_Down" "Meta+U" ];
        "Switch One Desktop Up" = [ "Meta+Page_Up" "Meta+I" ];
        "Overview" = "Meta+`";
        "Window Grow Horizontal" = "Meta+Equal";
        "Window Shrink Horizontal" = "Meta+Minus";
        "Window Grow Vertical" = "Meta+Shift+Equal";
        "Window Shrink Vertical" = "Meta+Shift+Minus";
      };
      plasmashell = {
        "activate application launcher" = "Meta+Space";
      };
      ksmserver = {
        "Lock Session" = "Ctrl+Alt+L";
        "Log Out" = "Ctrl+Meta+Q";
      };
      "org.kde.krunner.desktop" = {
        "RunClipboard" = "Meta+V";
      };
      klipper = {
        "show_klipper_popup" = "Meta+Shift+V";
        "clipboard_action" = "Meta+C";
      };
      org_kde_powerdevil = {
        "powerProfile" = "Meta+Shift+P";
      };
      "org.kde.spectacle.desktop" = {
        "RectangularRegionScreenShot" = "Print";
        "FullScreenScreenShot" = "Ctrl+Print";
        "ActiveWindowScreenShot" = "Alt+Print";
      };
      kmix = {
        "increase_volume" = "Volume Up";
        "decrease_volume" = "Volume Down";
        "mute" = "Volume Mute";
      };
    };

    # ── 自定义命令快捷键 ────────────────────────────────────────────────────────
    hotkeys.commands = {
      "launch-terminal" = {
        name = "Launch Terminal";
        key = "Meta+Return";
        command = "kitty";
      };
      "launch-browser" = {
        name = "Launch Browser";
        key = "Meta+B";
        command = "zen";
      };
      "launch-file-manager" = {
        name = "Launch File Manager";
        key = "Meta+E";
        command = "dolphin";
      };
    };

    # ── 其他配置文件 ────────────────────────────────────────────────────────────
    configFile = {
      "klipperrc"."General" = {
        IgnoreImages = false;
        KeepClipboardContents = true;
        MaxClipItems = 50;
        NoNullClipboard = true;
        Synchronize = false;
      };
      # 平铺窗口间距
      "kwinrc"."Tiling" = {
        padding = 4;
      };
    };
  };
}
