{ pkgs, ... }:
{
  # KDE Plasma 6 桌面环境及相关系统服务。
  services = {
    desktopManager.plasma6.enable = true;
    gvfs.enable = true;
    dbus.packages = [ pkgs.kdePackages.kwallet ];
  };

  environment = {
    systemPackages = with pkgs; [
      kdePackages.ark
      kdePackages.spectacle
      kdePackages.gwenview
      kdePackages.okular
      kdePackages.kate
      kdePackages.kcalc
      kdePackages.konsole
      kdePackages.kde-cli-tools
      kdePackages.kscreen
      kdePackages.powerdevil
      kdePackages.bluedevil
      kdePackages.kwayland
      kdePackages.kwayland-integration
      kdePackages.fcitx5-qt
      kdePackages.breeze
      kdePackages.breeze-icons
      kdePackages.breeze-gtk
      kdePackages.qtstyleplugin-kvantum
      whitesur-kde
      whitesur-icon-theme
      whitesur-gtk-theme
      whitesur-cursors
    ];
    plasma6.excludePackages = [ pkgs.kdePackages.dolphin ];

    # greetd 启动的图形会话不会 source Home Manager 的 ~/.profile。
    sessionVariables = {
      GTK_IM_MODULE = "fcitx";
      QT_IM_MODULE = "fcitx";
      XMODIFIERS = "@im=fcitx";
      GLFW_IM_MODULE = "fcitx5";
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.kdePackages.xdg-desktop-portal-kde
      pkgs.xdg-desktop-portal-termfilechooser
    ];
    config.common."org.freedesktop.impl.portal.FileChooser" = [ "termfilechooser" ];
  };

  programs.kdeconnect.enable = true;
}
