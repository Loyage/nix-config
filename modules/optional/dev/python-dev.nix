{ lib
, pkgs
, ...
}:
let
  commonPackages = with pkgs; [
    # 基础开发工具
    python3
    uv
    micromamba
    jupyter
    pkg-config

    # Python 项目常用工具
    python3Packages.pip
    python3Packages.virtualenv
    python3Packages.ipython
    ruff
    pyright

    # Python 库常用依赖
    zlib
    zlib-ng
    openssl
    icu
    libxml2
    glib
    libffi

    # 常用动态链接库
    ncurses
    expat
  ];

  linuxPackages = commonPackages ++ (with pkgs; [
    conda
    stdenv.cc.cc
    libxcrypt-legacy # 某些旧版 Conda 环境需要
  ]);

  darwinPackages = commonPackages ++ (with pkgs; [
    clang
    libiconv
  ]);

  pythonFHS = pkgs.buildFHSEnv {
    name = "python-dev";
    targetPkgs = _: linuxPackages;
    runScript = "zsh";
    profile = ''
      export LANG=C.UTF-8
    '';
  };
in
{
  environment.systemPackages =
    lib.optionals pkgs.stdenv.isLinux [ pythonFHS ]
    ++ lib.optionals pkgs.stdenv.isDarwin darwinPackages;
}
