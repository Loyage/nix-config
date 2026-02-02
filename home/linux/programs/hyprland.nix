{ pkgs
, ...
}:
{
  home.packages = with pkgs; [
    xwayland-satellite
  ];

  systemd.user.services.hyprland-polkit = {
    Unit = {
      Description = "PolicyKit Authentication Agent for Hyprland";
      After = [
        "graphical-session.target"
      ];
      Wants = [ "graphical-session-pre.target" ];
    };
    Install.WantedBy = [ "graphical-session.target" ];
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  services.hypridle.enable = true;
}
