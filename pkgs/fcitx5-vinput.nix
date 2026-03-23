{ pkgs, ... }:

pkgs.stdenv.mkDerivation rec {
  pname = "fcitx5-vinput";
  version = "1.1.15-1";

  src = pkgs.fetchurl {
    url = "https://github.com/xifan2333/fcitx5-vinput/releases/download/v1.1.15/fcitx5-vinput_1.1.15-1_amd64.deb";
    sha256 = "sha256-lVx93uTZDpr0G40euXBPLC1EUZ5xkmzTUcErTXKTtnI=";
  };

  nativeBuildInputs = with pkgs; [
    dpkg
    autoPatchelfHook
    qt5.wrapQtAppsHook
  ];

  buildInputs = with pkgs; [
    fcitx5
    libsForQt5.fcitx5-qt
    qt5.qtbase
    pipewire
    curl
    nlohmann_json
    cli11
    # 我们保留这些系统库作为依赖，但 autoPatchelf 会优先使用包内自带的动态库
    libarchive
    openssl
    systemd
    fmt
    sdbus-cpp
    openblas
    alsa-lib
  ];

  unpackPhase = "dpkg-deb -x $src .";

  installPhase = ''
    mkdir -p $out
    # 解压后的目录结构通常是 usr/...
    cp -r usr/* $out/

    # 这里的 .deb 包路径可能有点特殊 (Ubuntu 风格的 x86_64-linux-gnu)
    # 我们统一把库移到标准的 lib 路径下，方便 autoPatchelf 处理
    if [ -d "$out/lib/x86_64-linux-gnu" ]; then
      cp -r $out/lib/x86_64-linux-gnu/* $out/lib/
      rm -rf $out/lib/x86_64-linux-gnu
    fi

    # 修正 systemd 服务路径
    mkdir -p $out/lib/systemd/user
    mv $out/share/systemd/user/*.service $out/lib/systemd/user/ || true
  '';

  # 强制 autoPatchelf 搜索我们移动后的 lib 路径
  appendRunpaths = [ "${placeholder "out"}/lib/fcitx5-vinput" ];
}
