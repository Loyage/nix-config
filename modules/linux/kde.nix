{ pkgs, ... }:
{
  # KDE Plasma 6 桌面环境
  services.desktopManager.plasma6.enable = true;

  # 将 Plasma session 注册到 displayManager，让 greetd 能发现它
  services.displayManager.sessionPackages = [ pkgs.kdePackages.plasma-workspace ];

  # KDE 应用程序
  environment.systemPackages = with pkgs; [
    # 系统工具
    kdePackages.dolphin # 文件管理器
    kdePackages.ark # 压缩包管理
    kdePackages.spectacle # 截图工具
    kdePackages.gwenview # 图片查看器
    kdePackages.okular # PDF 阅读器
    kdePackages.kate # 文本编辑器
    kdePackages.kcalc # 计算器
    kdePackages.konsole # 终端

    # 系统设置
    kdePackages.kde-cli-tools
    kdePackages.kscreen # 屏幕管理
    kdePackages.powerdevil # 电源管理
    kdePackages.bluedevil # 蓝牙管理

    # Wayland 支持
    kdePackages.kwayland
    kdePackages.kwayland-integration

    # 主题和外观
    kdePackages.breeze
    kdePackages.breeze-icons
    kdePackages.breeze-gtk
  ];

  # XDG 桌面门户（KDE portal 会与 Hyprland portal 共存，系统自动选择）
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];
    # 不设置 default，让系统根据当前桌面环境自动选择
  };

  # GVFS 支持（网络文件系统、回收站等）
  services.gvfs.enable = true;

  # 允许 KDE Connect（如果需要与手机连接）
  programs.kdeconnect.enable = true;

  # D-Bus 服务
  services.dbus.packages = [ pkgs.kdePackages.kwallet ];
}
