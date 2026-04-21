{ pkgs
, config
, ...
}: {
  home.packages = with pkgs; [
    python3
    cargo
    lua
    luarocks
    nodejs

    cmake
    gnumake
    gcc
  ];

  home.file.".npmrc".text = ''
    prefix=${config.home.homeDirectory}/.npm
    min-release-age=7
  '';
  xdg.configFile."pip/pip.conf".text = ''
    [global]
    index-url = https://mirror.nju.edu.cn/pypi/web/simple
    format = columns
  '';
}
