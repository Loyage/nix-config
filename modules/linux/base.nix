{ pkgs
, config
, myvars
, ...
}:
let
  inherit (myvars) username;
in
{
  # 基础系统设置
  time.timeZone = "Asia/Shanghai";
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

  # 引导加载程序通用配置
  boot.loader = {
    systemd-boot.enable = false;
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      device = "nodev"; # UEFI 系统必须用 nodev
      efiSupport = true;
      configurationLimit = 2;
    };
  };

  # 休眠基础配置
  powerManagement.enable = true;
  systemd.targets.hibernate.enable = true;

  # 用户配置
  users.users."${username}" = {
    isNormalUser = true;
    home = "/home/${username}";
    description = username;
    group = "loyage";
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.zsh;
  };
  users.groups.loyage = { };
  nix.settings.trusted-users = [ username ];

  # 网络管理
  networking.networkmanager.enable = true;

  # 程序与桌面环境启用
  programs.hyprland.enable = true;
  programs.niri.enable = true;

  # 安全相关
  security.pam.services.greetd.enableGnomeKeyring = true;

  # 基础服务
  services = {
    printing.enable = true;
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    power-profiles-daemon.enable = true;
    upower.enable = true;
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PubkeyAuthentication = true;
        PermitRootLogin = "no";
      };
    };
    flatpak.enable = true;
    xserver.enable = true;

    greetd = {
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
            --remember-session \
            --theme "border=magenta;text=cyan;prompt=green;time=red;action=blue;button=yellow;container=black;input=red"
          '';
        };
      };
    };
  };

  # 硬件与蓝牙
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
        FastConnectable = true;
      };
      Policy = {
        AutoEnable = true;
      };
    };
  };

  # Systemd 优化
  systemd.settings.Manager = {
    DefaultTimeoutStopSec = "5s";
  };
}
