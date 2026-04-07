{
  description = "Nix for macOS configuration";

  nixConfig = {
    substituters = [
      "https://mirror.tuna.tsinghua.edu.cn/nix-channels/store" # Tsinghua University Mirror
      "https://mirror.sjtu.edu.cn/nix-channels/store" # Shanghai Jiao Tong University Mirror
      "https://cache.nixos.org" # Official NixOS Cache
      "https://nix-community.cachix.org" #Community Cachix Cache
    ];
    trusted-public-keys = [
      # nix community's cache server public key
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      # nixos官方缓存key，在nixos中硬编码，可以不需要，但是在nix-darwin中需要显式添加
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
  };

  inputs = {
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    nixpkgs-stable-darwin.url = "github:nixos/nixpkgs/nixpkgs-25.05-darwin";
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
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
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
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.5.2";
    fcitx5-vinput = {
      url = "github:xifan2333/fcitx5-vinput";
      flake = false;
    };
    catppuccin.url = "github:catppuccin/nix";
  };

  # The `outputs` function will return all the build results of the flake.
  # A flake can have many use cases and different types of outputs,
  # parameters in `outputs` are defined in `inputs` and can be referenced by their names.
  # However, `self` is an exception, this special parameter points to the `outputs` itself (self-reference)
  # The `@` syntax here is used to alias the attribute set of the inputs's parameter, making it convenient to use inside the function.
  outputs =
    inputs @ { self
    , nixpkgs
    , nix-darwin
    , home-manager
    , nix-homebrew
    , ...
    }:
    let
      inherit (inputs.nixpkgs) lib;
      mylib = import ./lib { inherit lib; };
      myvars = import ./vars { inherit lib; };

      # specialArgs 内的参数可以在各个模块中访问到，只需要你添加到函数输入变量中即可
      specialArgs =
        { inherit inputs myvars mylib; };

      # 生成远程服务器 home-manager 配置的函数
      mkRemoteHome = system:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import inputs.nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };
          extraSpecialArgs = specialArgs;
          modules = [ ./home/remote ];
        };

      # 本机特定配置目录（gitignored，需要 --impure 构建）
      # 新机器部署：cp -r hosts/local.example hosts/local && 编辑其中的文件
      localHostDir = /home/loyage/nix-config/hosts/local;

      mkNixosSystem =
        nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = "x86_64-linux";
          pkgs = import inputs.nixpkgs-unstable {
            system = "x86_64-linux";
            overlays = [
              inputs.nix-openclaw.overlays.default
              (final: prev: {
                fcitx5-vinput = final.callPackage ./pkgs/fcitx5-vinput.nix { inherit inputs; };
              })
            ];
            config.allowUnfree = true;
          };
          modules = [
            ./modules/base
            ./modules/linux

            inputs.nix-flatpak.nixosModules.nix-flatpak
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = specialArgs;
                backupFileExtension = "home-manager.backup";
                users.${myvars.username} = import ./home/linux;
              };
            }
          ] ++ (
            # 导入 hosts/local/ 中所有 .nix 文件（硬件配置、主机名等）
            if builtins.pathExists localHostDir
            then mylib.scanPaths localHostDir
            else throw "hosts/local/ 不存在！请执行: cp -r hosts/local.example hosts/local 并编辑配置"
          );
        };
    in
    {
      # macOS 配置
      darwinConfigurations."${myvars.darwinHostname}" = nix-darwin.lib.darwinSystem {
        inherit specialArgs;
        system = "aarch64-darwin";
        pkgs = import inputs.nixpkgs-unstable {
          system = "aarch64-darwin";
          config.allowUnfree = true;
        };
        modules = [
          ./modules/base
          ./modules/darwin

          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = specialArgs;
              backupFileExtension = "home-manager.backup";
              users.${myvars.username} = import ./home/darwin;
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
              };
              mutableTaps = false;
            };
          }
        ];
      };

      # NixOS 配置（单一配置，本机特定部分在 hosts/local/）
      nixosConfigurations.nixos = mkNixosSystem;

      # 远程服务器 home-manager 配置（用于 Ubuntu/Debian 等非 NixOS 系统）
      # 用法：home-manager switch --flake .#remote
      #       home-manager switch --flake .#remote-aarch64
      homeConfigurations = {
        "remote" = mkRemoteHome "x86_64-linux";
        "remote-aarch64" = mkRemoteHome "aarch64-linux";
      };
    };
}
