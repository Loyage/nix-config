{
  description = "Nix for macOS configuration";

  nixConfig = {
    substituters = [
      "https://mirror.tuna.tsinghua.edu.cn/nix-channels/store" # Tsinghua University Mirror
      # "https://mirror.sjtu.edu.cn/nix-channels/store" # Shanghai Jiao Tong University Mirror
      "https://cache.nixos.org" # Official NixOS Cache
      "https://nix-community.cachix.org" # Community Cachix Cache
    ];
    trusted-public-keys = [
      # nix community's cache server public key
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      # nixos官方缓存key，在nixos中硬编码，可以不需要，但是在nix-darwin中需要显式添加
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
  };

  inputs = {
    # nixpkgs-master.url = "github:nixos/nixpkgs/master";
    # nixpkgs-stable-darwin.url = "github:nixos/nixpkgs/nixpkgs-25.05-darwin";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    nix-darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-services = {
      url = "github:homebrew/homebrew-services";
      flake = false;
    };
    aerospace = {
      url = "github:nikitabobko/homebrew-tap";
      flake = false;
    };
    daipeihust = {
      url = "github:daipeihust/homebrew-tap";
      flake = false;
    };
    stablyai-orca = {
      url = "github:stablyai/homebrew-orca";
      flake = false;
    };
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    hibiki = {
      url = "github:linuxmobile/hibiki";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nix-openclaw = {
      url = "github:openclaw/nix-openclaw";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "home-manager";
      inputs.home-manager.follows = "home-manager";
    };
    fcitx5-vinput = {
      url = "github:xifan2333/fcitx5-vinput";
      flake = false;
    };
    catppuccin.url = "github:catppuccin/nix";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    academic-research-skills = {
      # ARS 学术研究技能套件（Pi wrapper），纯文件无 npm 依赖。
      url = "github:Imbad0202/academic-research-skills";
      flake = false;
    };
    orca = {
      url = "github:stslex/orca-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    deepseek-harness-flake = {
      # DeepSeek Harness（dsh）home-manager 模块，独立 flake（~ 下单独 git 仓库）
      # ⚠️ 上传 GitHub 后务必改为：url = "github:<你的用户名>/deepseek-harness-flake";
      #    然后 nix flake lock --update-input deepseek-harness-flake
      # （用绝对路径：相对 path: 会在纯模式下被解析到 /nix/store 而报错）
      url = "github:Loyage/deepseek-harness-flake";
    };
  };

  # The `outputs` function will return all the build results of the flake.
  # A flake can have many use cases and different types of outputs,
  # parameters in `outputs` are defined in `inputs` and can be referenced by their names.
  # However, `self` is an exception, this special parameter points to the `outputs` itself (self-reference)
  # The `@` syntax here is used to alias the attribute set of the inputs's parameter, making it convenient to use inside the function.
  outputs =
    inputs@{
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      nix-homebrew,
      agenix,
      git-hooks,
      ...
    }:
    let
      inherit (inputs.nixpkgs) lib;
      mylib = import ./lib { inherit lib; };
      myvars = import ./vars;

      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];
      forAllSystems =
        f:
        builtins.listToAttrs (
          map (system: {
            name = system;
            value = f system;
          }) systems
        );
      preCommit = import ./git-hooks.nix { inherit self git-hooks; };

      # specialArgs 内的参数可以在各个模块中访问到，只需要你添加到函数输入变量中即可
      specialArgs = { inherit inputs myvars mylib; };
      desktopProfile = {
        graphical = true;
        systemManaged = true;
      };
      headlessProfile = {
        graphical = false;
        systemManaged = false;
      };

      # 生成无 root 权限、无图形桌面的 standalone home-manager 配置
      mkHeadlessHome =
        system:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import inputs.nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };
          extraSpecialArgs = specialArgs // { hostProfile = headlessProfile; };
          modules = [
            ./home/remote-server.nix
            agenix.homeManagerModules.default
          ];
        };

      # 本机特定配置目录（gitignored，需要 --impure 构建）
      # 新机器部署：cp -r hosts/local.example hosts/local && 编辑其中的文件
      localHostDir = /home/loyage/nix-config/hosts/local;

      mkNixosSystem = nixpkgs.lib.nixosSystem {
        specialArgs = specialArgs // { hostProfile = desktopProfile; };
        system = "x86_64-linux";
        pkgs = import inputs.nixpkgs-unstable {
          system = "x86_64-linux";
          overlays = import ./overlays inputs;
          config.allowUnfree = true;
        };
        modules = [
          ./modules/base
          ./modules/linux
          ./modules/optional/desktop
          ./modules/optional/dev/python-dev.nix
          agenix.nixosModules.default

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = specialArgs // { hostProfile = desktopProfile; };
              backupFileExtension = "home-manager.backup";
              users.${myvars.username} = import ./home/nixos.nix;
            };
          }
        ]
        # 导入 hosts/local/ 中所有 .nix 文件（硬件配置、主机名等）
        ++ mylib.scanPaths localHostDir;
      };
    in
    {
      # pre-commit hooks 检查（nix flake check 会构建并运行）
      checks = forAllSystems (system: {
        pre-commit-check = preCommit system;
      });

      # 开发 shell：进入后自动安装 git pre-commit hooks
      devShells = forAllSystems (system: {
        default = inputs.nixpkgs-unstable.legacyPackages.${system}.mkShell {
          shellHook = (preCommit system).shellHook;
        };
      });

      # macOS 配置
      darwinConfigurations."${myvars.macosHostname}" = nix-darwin.lib.darwinSystem {
        specialArgs = specialArgs // { hostProfile = desktopProfile; };
        system = "aarch64-darwin";
        pkgs = import inputs.nixpkgs-unstable {
          system = "aarch64-darwin";
          config.allowUnfree = true;
        };
        modules = [
          ./modules/base
          ./modules/macos
          ./modules/optional/dev/python-dev.nix
          agenix.darwinModules.default
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = specialArgs // { hostProfile = desktopProfile; };
              backupFileExtension = "home-manager.backup";
              users.${myvars.username} = import ./home/mac.nix;
            };
          }

          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              user = myvars.username;
              enableRosetta = true;
              autoMigrate = true;
              taps = {
                "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
                "homebrew/homebrew-cask" = inputs.homebrew-cask;
                "homebrew/homebrew-core" = inputs.homebrew-core;
                "homebrew/homebrew-services" = inputs.homebrew-services;
                "nikitabobko/homebrew-tap" = inputs.aerospace;
                "daipeihust/homebrew-tap" = inputs.daipeihust;
                "stablyai/homebrew-orca" = inputs.stablyai-orca;
              };
              mutableTaps = false;
            };
          }
        ];
      };

      # NixOS 配置（仅当 hosts/local/ 存在时定义，否则 nix flake check 在非 Linux 机器上会失败）
      nixosConfigurations = if builtins.pathExists localHostDir then { nixos = mkNixosSystem; } else { };

      # 无 root 权限、无图形桌面的 standalone home-manager 配置。
      # remote 名称保留为兼容别名；新命令使用语义更准确的 headless。
      homeConfigurations = {
        "headless" = mkHeadlessHome "x86_64-linux";
        "headless-aarch64" = mkHeadlessHome "aarch64-linux";
        "remote" = mkHeadlessHome "x86_64-linux";
        "remote-aarch64" = mkHeadlessHome "aarch64-linux";
      };
    };
}
