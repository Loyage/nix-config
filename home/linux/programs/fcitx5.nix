{ pkgs
, config
, lib
, ...
}:
{
  home.sessionVariables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    GLFW_IM_MODULE = lib.mkForce "fcitx5";
    XMODIFIERS = "@im=fcitx";
  };

  # Rime 配置文件符号链接
  home.file.".local/share/fcitx5/rime/default.custom.yaml" = {
    source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/nix-config/config/rime/default.custom.yaml";
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        (fcitx5-rime.override {
          rimeDataPkgs = [
            pkgs.rime-ice
          ];
        })
        fcitx5-gtk # gtk im module
        fcitx5-mellow-themes
      ];
    };
  };
}
