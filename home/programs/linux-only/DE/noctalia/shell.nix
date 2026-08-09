{ ... }:
{
  programs.noctalia.settings = {
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
      session.actions = [
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
    };
  };
}
