{ pkgs
, myvars
, ...
}:
let
  username = myvars.username;
  hostname = myvars.nixosHostname ;
in 
{
  networking.hostName = hostname;
  users.users."${username}" = {
    home = "/home/${username}";
    description = username;
    isSystemUser = true;
    group = "loyage";
    shell = pkgs.zsh;
  };
  users.groups.loyage = {};
  nix.settings.trusted-users = [ username ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  services.flatpak.enable = true;

  programs.hyprland = {
    enable = true;
  };
  programs.hyprlock.enable = true;
  services.hypridle.enable = true;

  services.xserver.enable = true;
  # services.displayMangaer.sddm.wayland.enable = true;
  services.displayManager.sddm.enable = true;
}
