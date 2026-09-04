# 本机特定配置：主机名、GRUB 双系统引导、休眠恢复设备等
# 复制到 hosts/local/ 后根据本机情况修改
{ myvars, ... }:
{
  networking.hostName = "CHANGE-ME";

  # 每台机器只保留实际需要的登录密钥，避免所有主机共享整套授权。
  # 首次迁移可先使用 myvars.authorizedKeys，确认登录后再缩小列表。
  home-manager.users.${myvars.username}.localConfig.authorizedKeys = myvars.authorizedKeys;

  boot = {
    loader.grub.extraEntries = ''
      menuentry "Windows" {
        insmod part_gpt
        insmod fat
        insmod search_fs_uuid
        insmod chain
        search --fs-uuid --set=root CHANGE-ME
        chainloader /EFI/Microsoft/Boot/bootmgfw.efi
      }
    '';

    resumeDevice = "/dev/disk/by-uuid/CHANGE-ME";
    kernelParams = [ "resume=UUID=CHANGE-ME" ];
  };
}
