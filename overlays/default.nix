inputs: [
  (final: prev: {
    wechat = final.callPackage (inputs.nixpkgs-unstable + "/pkgs/by-name/we/wechat/linux.nix") {
      pname = "wechat";
      version = "4.1.1.4";
      src = final.fetchurl {
        url = "https://dldir1v6.qq.com/weixin/Universal/Linux/WeChatLinux_x86_64.AppImage";
        hash = "sha256-RX26ArkbAxzdRBLu4HT7v/udnQax5Q/Bgi00hw4RSZA=";
      };
      meta = prev.wechat.meta;
    };
  })

  # (final: prev: {
  #   fcitx5-vinput = final.callPackage ./pkgs/fcitx5-vinput.nix { inherit inputs; };
  # })
]
