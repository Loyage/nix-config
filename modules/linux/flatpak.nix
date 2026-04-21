{
  services.flatpak = {
    enable = true;
    update.auto.enable = true;
    remotes = [
      {
        name = "flathub";
        location = "https://mirror.sjtu.edu.cn/flathub/flathub.flatpakrepo";
      }
    ];
    packages = [
    ];
  };
}
