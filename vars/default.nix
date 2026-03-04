{ lib }:
{
  # 用户信息（所有主机共享）
  username = "loyage";
  useremail = "792058350@qq.com";

  # macOS 主机
  darwinHostname = "LoyagedeMacBook-Air";

  # NixOS 主机列表
  nixosHosts = {
    # ThinkPad 办公本
    thinkpad = {
      hostname = "thinkpad";
      system = "x86_64-linux";
    };
    # Legion 游戏本
    legion = {
      hostname = "legion";
      system = "x86_64-linux";
    };
  };

  # 默认 NixOS 主机名（保持向后兼容）
  nixosHostname = "thinkpad";
}
