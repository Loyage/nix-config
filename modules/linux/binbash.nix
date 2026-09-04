{
  pkgs,
  ...
}:
{
  # 创建 /bin/bash 符号链接，兼容硬编码 /bin/bash 的工具。
  system.activationScripts.binbash.text = ''
    ${pkgs.coreutils}/bin/mkdir -p /bin
    ${pkgs.coreutils}/bin/ln -sfn ${pkgs.bash}/bin/bash /bin/bash
  '';
}
