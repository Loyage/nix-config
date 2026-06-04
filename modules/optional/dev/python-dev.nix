{ pkgs
, ...
}:
let
  pythonFHS = pkgs.buildFHSEnv
    {
      name = "python-dev";
      targetPkgs = pkgs: with pkgs; [
        # 基础开发工具
        uv
        conda
        jupyter
        pkg-config
        stdenv.cc.cc

        # Python 库常用依赖
        zlib
        zlib-ng
        openssl
        icu
        libxml2
        glib
        libffi
        libxcrypt-legacy # 某些旧版 Conda 环境需要

        # 常用动态链接库
        ncurses
        expat
      ];
      runScript = "zsh";
      profile = ''
        export LANG=C.UTF-8
      '';
    };
in
{
  environment.systemPackages = [
    pythonFHS
  ];
}
