{
  pkgs,
  myvars,
  ...
}:
let
  cacheSettings = (import ../../flake.nix).nixConfig;
in
{
  nix = {
    enable = true;
    package = pkgs.nix;
    settings = cacheSettings // {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      # 个人管理的机器允许该用户指定 substituter/构建参数。trusted-users
      # 接近 root 权限，不应把此模块原样用于不受信任的多用户主机。
      trusted-users = [ myvars.username ];
      builders-use-substitutes = true;
    };
  };
}
