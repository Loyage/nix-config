{ pkgs, ... }:
{
  system.stateVersion = "24.05"; # 请根据实际 NixOS 版本调整

  programs.zsh.enable = true;

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
  ];
}