###################################################################################
#
#  macOS's System configuration
#
#  All the configuration options are documented here:
#    https://daiderd.com/nix-darwin/manual/index.html#sec-options
#
###################################################################################
{
  system = {
    stateVersion = 5; # Define the state version of the system configuration.
    primaryUser = "loyage";
  };
  programs.zsh.enable = true;
  # Add ability to used TouchID for sudo authentication
  security.pam.services.sudo_local.touchIdAuth = true;

  # SSH 服务：监听 2222 端口（与 NixOS 一致），仅允许公钥登录
  # 说明：该 nix-darwin 版本的 openssh 模块通过 Apple 内置 sshd（launchd）启停，
  #       端口等配置写入 /etc/ssh/sshd_config.d/100-nix-darwin.conf（extraConfig）。
  services.openssh = {
    enable = true;
    extraConfig = ''
      Port 2222
      PasswordAuthentication no
      PubkeyAuthentication yes
      PermitRootLogin no
    '';
  };
}
