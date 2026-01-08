{ config, ... }:
let
  dev-tools = [
    "kitty" # terminal emulator
    "visual-studio-code"
    "zen"
  ];
  utilities = [
    "jordanbaird-ice" # menu bar management tool
    "keycastr" # keyboard visualizer
    "the-unarchiver"
    "iina" # media player
    "transmission" # bit torrent client
    "aerospace"
  ];
  social-media = [
    "wechat"
    "qq"
    # "discord"
    "telegram"
  ];
  entertainment = [
    "neteasemusic"
  ];
  productivity = [
    "zotero"
  ];
in
{
  homebrew = {
    enable = true;
    # casks is for gui softwares, brews for shell softwares
    casks = dev-tools ++ utilities ++ social-media ++ entertainment ++ productivity;
    brews = [
      "im-select" # auto select input method
    ];
    masApps = { };
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
    onActivation.cleanup = "zap";
    taps = builtins.attrNames config.nix-homebrew.taps;
  };
}
