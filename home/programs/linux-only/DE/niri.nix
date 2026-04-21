{ pkgs
, ...
}:
{
  home.packages = with pkgs; [
    # Niri v25.08 will create X11 sockets on disk, export $DISPLAY, and spawn `xwayland-satellite` on-demand when an X11 client connects
    xwayland-satellite
  ];

  systemd.user.services.niri-flake-polkit = {
    Unit = {
      Description = "PolicyKit Authentication Agent provided by niri-flake";
      After = [
        "graphical-session.target"
      ];
      Wants = [ "graphical-session-pre.target" ];
    };
    Install.WantedBy = [ "niri.service" ];
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
}
