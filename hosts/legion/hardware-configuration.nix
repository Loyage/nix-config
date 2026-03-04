# 在新机器上运行以下命令生成此文件：
# sudo nixos-generate-config --show-hardware-config > hardware-configuration.nix
#
# 然后将生成的内容替换此文件

{ config, lib, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # TODO: 替换为新机器的实际配置
  # 运行 nixos-generate-config 后复制以下内容：
  # - boot.initrd.availableKernelModules
  # - boot.kernelModules
  # - fileSystems
  # - swapDevices
  # - hardware.cpu.* (intel 或 amd)

  boot.initrd.availableKernelModules = [ ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/REPLACE-WITH-YOUR-UUID";
    fsType = "ext4"; # 或 btrfs
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/REPLACE-WITH-YOUR-UUID";
    fsType = "vfat";
  };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
