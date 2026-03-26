# 由 nixos-generate-config 生成，新机器上执行：
#   sudo nixos-generate-config --show-hardware-config > hosts/local/hardware-configuration.nix
# 然后根据需要调整（如 btrfs subvol、compress 等）
{ config, lib, modulesPath, ... }:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" ];
  boot.kernelModules = [ "kvm-intel" ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/CHANGE-ME";
    fsType = "btrfs";
    options = [ "subvol=root" "compress=zstd" ];
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/CHANGE-ME";
    fsType = "vfat";
  };

  swapDevices = [{ device = "/dev/disk/by-uuid/CHANGE-ME"; }];
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
