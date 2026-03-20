{ ... }:
{
  boot = {
    loader.grub.extraEntries = ''
      menuentry "Windows 11" {
        insmod part_gpt
        insmod fat
        insmod search_fs_uuid
        insmod chain
        search --fs-uuid --set=root A0DF-3002
        chainloader /EFI/Microsoft/Boot/bootmgfw.efi
      }
    '';

    # 休眠恢复设备
    resumeDevice = "/dev/disk/by-uuid/697709dd-619f-40a0-a0dd-3be148c9a3f1";
    kernelParams = [ "resume=UUID=697709dd-619f-40a0-a0dd-3be148c9a3f1" ];
  };
}
