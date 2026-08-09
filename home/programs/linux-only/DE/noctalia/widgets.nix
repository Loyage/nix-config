{ ... }:
{
  programs.noctalia.settings = {
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
  };
}
