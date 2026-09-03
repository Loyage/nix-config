_: {
  programs.noctalia.settings = {
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
  };
}
