{ pkgs, myvars, ... }:
{
  system.stateVersion = "24.05"; # 请根据实际 NixOS 版本调整

  programs.zsh.enable = true;

  fonts.packages = with pkgs; [
    # nerdfonts
    # https://github.com/NixOS/nixpkgs/blob/nixos-unstable-small/pkgs/data/fonts/nerd-fonts/manifests/fonts.json
    nerd-fonts.symbols-only # symbols icon only
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.iosevka

    # Adobe 以 Source Han Sans/Serif 的名称发布此系列字体
    source-sans # 无衬线字体，不含汉字。字族名叫 Source Sans 3，以及带字重的变体（VF）
    source-serif # 衬线字体，不含汉字。字族名叫 Source Serif 4，以及带字重的变体
    # Source Hans 系列汉字字体由 Adobe + Google 共同开发
    source-han-sans # 思源黑体
    source-han-serif # 思源宋体
    source-han-mono # 思源等宽

    maple-mono.NF-CN-unhinted
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji

    lxgw-wenkai-screen
    font-awesome
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
