{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    obs-studio
    wemeet
    xdg-desktop-portal-hyprland # 解决wemeet niri/hyprland下共享屏幕问题
  ];
}
