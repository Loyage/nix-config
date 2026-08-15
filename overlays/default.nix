inputs: [
  inputs.nix-openclaw.overlays.default

  (final: prev: {
    # 上游 deepseek-harness 的 packageManager 要求 pnpm@11.7.0；11.2.x 解析
    # allowBuilds 里的 file: 协议 key 会抛 ERR_PNPM_INVALID_VERSION_UNION，
    # 11.7.0 起才支持 depPath 形式的条目，故 pin 到 11.7.0。
    pnpm_11 = prev.pnpm_11.overrideAttrs (old: {
      version = "11.7.0";
      src = final.fetchurl {
        url = "https://registry.npmjs.org/pnpm/-/pnpm-11.7.0.tgz";
        hash = "sha256-3q+n7JihIYtqBHKJuS++I5XB4i00lbtxFlMBMhjuFe4=";
      };

      # nixpkgs 的 installCheck 硬编码了版本号，需同步
      installCheckPhase = ''
        runHook preInstallCheck
        tmp="$(mktemp -d)"
        mkdir -p "$tmp/home" "$tmp/project"
        printf '{"packageManager":"pnpm@11.99.99"}\n' > "$tmp/project/package.json"
        (
          cd "$tmp/project"
          version="$(HOME="$tmp/home" $out/bin/pnpm --version)"
          test "$version" = "11.7.0"
        )
        rm -rf "$tmp"
        runHook postInstallCheck
      '';

      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
        final.makeWrapper
      ];

      postInstall = (old.postInstall or "") + ''
        wrapProgram $out/bin/pnpm \
          --set-default pnpm_config_minimum_release_age 0
        wrapProgram $out/bin/pnpx \
          --set-default pnpm_config_minimum_release_age 0
      '';
    });

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
