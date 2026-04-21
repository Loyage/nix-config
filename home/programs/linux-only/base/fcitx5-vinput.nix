{ pkgs, config, ... }:

{
  home.packages = [ pkgs.fcitx5-vinput ];

  systemd.user.services.vinput-daemon = {
    Unit = {
      Description = "Fcitx5 Voice Input Daemon";
      After = [ "pipewire.service" ];
    };
    Service = {
      ExecStart = "${pkgs.fcitx5-vinput}/bin/vinput-daemon";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
