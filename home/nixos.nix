{
  inputs,
  ...
}:
{
  imports = [
    ./home-setting.nix
    ./programs/core-tools
    ./programs/linux-only
    inputs.deepseek-harness-flake.homeModules.default
    inputs.plasma-manager.homeModules.plasma-manager
  ];
}
