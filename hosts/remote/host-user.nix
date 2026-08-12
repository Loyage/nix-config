{ lib, ... }:
let
  remoteUsername = builtins.getEnv "USER";
  remoteHomeDirectory = builtins.getEnv "HOME";
in
{
  # 纯模式下 getEnv 返回 ""，此时跳过 mkForce，让 home-manager 使用自身默认值
  home.username = lib.mkIf (remoteUsername != "") (lib.mkForce remoteUsername);
  home.homeDirectory = lib.mkIf (remoteHomeDirectory != "") (lib.mkForce remoteHomeDirectory);
}
