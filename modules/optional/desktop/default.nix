{
  pkgs,
  config,
  myvars,
  lib,
  ...
}:
let
  inherit (myvars) username;
in
{
  imports = [ ./kde.nix ];

  programs = {
    niri.enable = true;
    hyprland.enable = false;
  };

  services = {
    # plasma6 与 niri 都设置 defaultSession，这里显式指定 niri。
    displayManager.defaultSession = lib.mkForce "niri";
    xserver.enable = true;
    greetd = {
      enable = true;
      settings.default_session = {
        user = username;
        command = "${pkgs.tuigreet}/bin/tuigreet --sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions:${config.services.displayManager.sessionData.desktops}/share/xsessions --time --asterisks --remember --remember-session";
      };
    };
  };
}
