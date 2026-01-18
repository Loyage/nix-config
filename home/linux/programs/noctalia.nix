{ lib
, config
, inputs
, pkgs
, ...
}:
{
  home.packages = [
    pkgs.qt6Packages.qt6ct # for icon theme
    pkgs.app2unit # Launch Desktop Entries (or arbitrary commands) as Systemd user units
  ]
  ++ (lib.optionals pkgs.stdenv.isx86_64 [
    pkgs.gpu-screen-recorder # recoding screen
  ]);

  imports = [
    inputs.noctalia.homeModules.default
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

