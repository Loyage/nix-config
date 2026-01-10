{ pkgs
, myvars
, ...
}:
let
  inherit (myvars) username nixosHostname;
in
{
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    # kernelPackages = with pkgs; [ linuxPackages_latest ];
  };

  networking.hostName = nixosHostname;
  networking.networkmanager.enable = true;
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  time.timeZone = "Asia/Shanghai";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "zh_CN.UTF-8";
    LC_IDENTIFICATION = "zh_CN.UTF-8";
    LC_MEASUREMENT = "zh_CN.UTF-8";
    LC_MONETARY = "zh_CN.UTF-8";
    LC_NAME = "zh_CN.UTF-8";
    LC_NUMERIC = "zh_CN.UTF-8";
    LC_PAPER = "zh_CN.UTF-8";
    LC_TELEPHONE = "zh_CN.UTF-8";
    LC_TIME = "zh_CN.UTF-8";
  };

  users.users."${username}" = {
    isSystemUser = true;
    home = "/home/${username}";
    description = username;
    group = "loyage";
    shell = pkgs.zsh;
  };
  users.groups.loyage = { };
  nix.settings.trusted-users = [ username ];

  programs.hyprland.enable = true;
  programs.niri.enable = true;

  services = {
    # 打印服务
    printing.enable = true;
    # 音频服务
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    openssh.enable = true;
    flatpak.enable = true;
    xserver.enable = true;

    greetd = {
      enable = true;
      settings = rec {
        initial_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd niri-session";
          user = "loyage";
        };
        default_session = initial_session;
      };
    };
    # displayManager.sddm.wayland.enable = true;
    # displayManager.sddm.enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        # Shows battery charge of connected devices on supported
        # Bluetooth adapters. Defaults to 'false'.
        Experimental = true;
        # When enabled other devices can connect faster to us, however
        # the tradeoff is increased power consumption. Defaults to
        # 'false'.
        FastConnectable = true;
      };
      Policy = {
        # Enable all controllers when they are found. This includes
        # adapters present on start as well as adapters that are plugged
        # in later on. Defaults to 'true'.
        AutoEnable = true;
      };
    };
  };
}
