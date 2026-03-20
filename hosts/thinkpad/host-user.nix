{ ... }:
{
  boot = {
    loader.grub.extraEntries = ''
      menuentry "Windows 10" {
        insmod part_gpt
        insmod fat
        insmod search_fs_uuid
        insmod chain
        search --fs-uuid --set=root 08FC-5E55
        chainloader /EFI/Microsoft/Boot/bootmgfw.efi
      }
    '';

    # 休眠恢复设备
    resumeDevice = "/dev/disk/by-uuid/df95c572-dab8-4e6e-b58f-622b312cb28c";
    kernelParams = [ "resume=UUID=df95c572-dab8-4e6e-b58f-622b312cb28c" ];
  };
}
