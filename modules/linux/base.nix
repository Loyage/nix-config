{ pkgs
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

  # 网络管理
  networking.networkmanager.enable = true;

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
  };

  # Systemd 优化
  systemd.settings.Manager = {
    DefaultTimeoutStopSec = "5s";
  };
}
