inputs: [
  (final: prev: {
    qq = prev.qq.overrideAttrs (_old: {
      version = "3.2.31-2026-07-20";
      src = final.fetchurl {
        url = "https://qqdl.gtimg.cn/qqfile/QQNT/9.9.32/release/c390e792/QQ_3.2.31_260710_amd64_01.deb";
        hash = "sha256-AvZ3/rHOAe0pOjx3YeXdhb15k29X3KpM21MXiuMOPW0=";
      };
    });

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
