{ inputs
, pkgs
, ...
}:
{
  imports = [
    inputs.noctalia.homeModules.default
    ./packages.nix
    ./environment.nix
    ./shell.nix
    ./idle.nix
    ./bar.nix
    ./widgets.nix
  ];

  programs.noctalia = {
    enable = true;
    settings = {
      location.auto_locate = true;
      wallpaper = {
        automation.enabled = true;
        transition_on_startup = true;
      };
      theme = {
        builtin = "Catppuccin";
        mode = "auto";
        source = "wallpaper";
      };
      dock = {
        enabled = true;
        reserve_space = false;
        smart_auto_hide = true;
        icon_size = 36;
        launcher_position = "start";
      };
    };
  };
}
