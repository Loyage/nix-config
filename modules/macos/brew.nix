{
  config,
  ...
}:
let
  trustedTaps = [
    "daipeihust/homebrew-tap"
  ];

  mkTap =
    tap:
    if builtins.elem tap trustedTaps then
      {
        name = tap;
        trusted = true;
      }
    else
      tap;

  dev-tools = [
    "ghostty"
    # "kitty"
    # "typora"
    "zen"
    "codex-app"
    "stablyai/orca/orca"
  ];
  utilities = [
    "jordanbaird-ice" # menu bar management tool
    "keycastr" # keyboard visualizer
    "the-unarchiver"
    "iina" # media player
    "transmission" # bit torrent client
    # "obs"
  ];
  social-media = [
    "wechat"
    "qq"
    # "discord"
    # "telegram"
  ];
  entertainment = [
    "neteasemusic"
  ];
  productivity = [
    # "zotero"
    # "wpsoffice-cn"
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
    # rebuild 只收敛声明，不执行未锁定的更新、升级或破坏性 zap 清理。
    # 需要维护时显式运行 `just brew-maintain`。
    onActivation = {
      autoUpdate = false;
      upgrade = false;
      cleanup = "none";
    };
    taps = builtins.map mkTap (builtins.attrNames config.nix-homebrew.taps);
  };
}
