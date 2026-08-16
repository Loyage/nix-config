# 本机特定配置：主机名、GRUB 双系统引导、休眠恢复设备等
# 复制到 hosts/local/ 后根据本机情况修改
{ ... }:
{
  networking.hostName = "CHANGE-ME";

  # 可选：只在这台主机构建 DeepSeek Harness（模块默认全机关闭；当前仅 legion 开启）
  # programs.deepseekHarness.enable = true;

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
