{ ... }:
{
  programs.noctalia.settings = {
    bar = {
      order = [ "mybar" ];
      mybar = {
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
            members = [
              "cpu"
              "ram"
              "temp"
            ];
            opacity = 0.4;
            padding = 6.0;
          }
        ];
      };
    };
  };
}
