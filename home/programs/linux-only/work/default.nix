{ pkgs
, mylib
, ...
}:
{
  imports = mylib.scanPaths ./.;
  home.packages = with pkgs;[
    wpsoffice-cn
    wemeet
    xdg-desktop-portal-hyprland # 解决wemeet niri/hyprland下共享屏幕问题
  ];
}
