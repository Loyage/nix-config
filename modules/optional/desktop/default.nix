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
  # default using: niri, KDE, greetd
  imports = [
    ./kde.nix
  ];

  programs.niri.enable = true;
  programs.hyprland.enable = false;

  # plasma6 与 niri 两个 NixOS 模块都会设置 defaultSession，这里显式指定 niri 为默认
  services.displayManager.defaultSession = lib.mkForce "niri";

  services.xserver.enable = true;
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        user = username;
        command = "${pkgs.tuigreet}/bin/tuigreet --sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions:${config.services.displayManager.sessionData.desktops}/share/xsessions --time --asterisks --remember --remember-session";
      };
    };
  };
}
