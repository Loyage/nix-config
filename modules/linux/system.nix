{ pkgs, myvars, ... }:
{
  system.stateVersion = "24.05"; # 请根据实际 NixOS 版本调整

  programs.zsh.enable = true;

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];

  security.sudo = {
    enable = true; # Enable sudo
    extraRules = [
      {
        users = [ myvars.username ];
        commands = [
          { command = "ALL"; options = [ "NOPASSWD" ]; } # Allow all commands without a password
        ];
      }
    ];
  };
}
