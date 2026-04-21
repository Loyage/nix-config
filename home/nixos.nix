{ inputs
, ...
}: {
  imports = [
    ./home-setting.nix
    ./programs/core-tools
    ./programs/linux-only
    inputs.plasma-manager.homeModules.plasma-manager
  ];
}
