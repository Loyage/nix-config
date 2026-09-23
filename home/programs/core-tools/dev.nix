{
  pkgs,
  config,
  ...
}:
{
  home = {
    # Node.js 仍由 Nix 提供；npm 的用户级全局包则放在可写目录，避免写入只读的 /nix/store。
    # 这样新机器激活 Home Manager 后无需运行 `npm config set prefix ...`。
    sessionVariables.NPM_CONFIG_PREFIX = "${config.home.homeDirectory}/.npm-global";
    sessionPath = [ "${config.home.homeDirectory}/.npm-global/bin" ];

    packages = with pkgs; [
      python3
      rustup
      lua
      luarocks
      nodejs
      bun

      cmake
      gnumake
      gcc
    ];
  };

  xdg.configFile."pip/pip.conf".text = ''
    [global]
    index-url = https://mirror.nju.edu.cn/pypi/web/simple
    format = columns
  '';
}
