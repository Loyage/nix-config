{
  pkgs,
  config,
  ...
}:
{
  home.packages = with pkgs; [
    python3
    rustup
    lua
    luarocks
    nodejs

    cmake
    gnumake
    gcc
  ];

  xdg.configFile."pip/pip.conf".text = ''
    [global]
    index-url = https://mirror.nju.edu.cn/pypi/web/simple
    format = columns
  '';
}
