###################################################################################
#
#  macOS's System configuration
#
#  All the configuration options are documented here:
#    https://daiderd.com/nix-darwin/manual/index.html#sec-options
#
###################################################################################
{ pkgs, myvars, ... }:
{
  system = {
    stateVersion = 5; # Define the state version of the system configuration.
    primaryUser = myvars.username;
    defaults.dock.mru-spaces = false;
  };
  programs.zsh.enable = true;

  # SSH 从 kitty 登录时 TERM=xterm-kitty；确保登录环境初始化前就能找到定义。
  environment.variables.TERMINFO_DIRS = [
    "${pkgs.kitty}/Applications/kitty.app/Contents/Resources/kitty/terminfo"
    "/usr/share/terminfo"
  ];
  # Add ability to used TouchID for sudo authentication
  security.pam.services.sudo_local.touchIdAuth = true;

  # SSH 服务：通过 macOS 内置 sshd（launchd）启用，仅允许公钥登录。
  # 不在这里改 Port：macOS 的 ssh.plist 由 launchd 监听 22 端口，
  # sshd_config 中的 Port 不会改变 launchd 的监听端口。
  services.openssh = {
    enable = true;
    extraConfig = ''
      PasswordAuthentication no
      PubkeyAuthentication yes
      PermitRootLogin no
    '';
  };
}
