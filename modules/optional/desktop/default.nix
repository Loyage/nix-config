{ pkgs
, config
, myvars
, ...
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

  services.xserver.enable = true;
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        user = username;
        command = ''
          ${pkgs.tuigreet}/bin/tuigreet \
          --sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions:${config.services.displayManager.sessionData.desktops}/share/xsessions \
          --time \
          --asterisks \
          --remember \
          --remember-session
        '';
      };
    };
  };
}
