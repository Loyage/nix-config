{ pkgs, ... }:
{
  home.packages = with pkgs; [
    qt6Packages.qt6ct
    app2unit
    gpu-screen-recorder
    grim
    slurp
    wl-clipboard-rs
    (tesseract.override {
      enableLanguages = [ "chi_sim" "eng" ];
    })
    imagemagick
    zbar
    translate-shell
    wf-recorder
    ffmpeg
    gifski
  ];
}
