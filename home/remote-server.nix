{ config, ... }:
{
  imports = [
    ./home-setting.nix
    ./programs/core-tools
  ];

  # agenix 机密：deepseek / mimo API key（standalone home-manager 级）
  # 与 NixOS/macOS 的系统级定义（modules/base/secrets.nix）等价，
  # 但 home-manager 的解密路径是 ${XDG_RUNTIME_DIR}/agenix/...（运行时展开），
  # 而不是系统级的 /run/agenix/...。
  age.secrets.deepseek-api-key = {
    file = ../secrets/deepseek-api-key.age;
    mode = "0400";
  };

  age.secrets.mimo-api-key = {
    file = ../secrets/mimo-api-key.age;
    mode = "0400";
  };

  # remote 上覆盖 pi 的 apiKey 路径，指向 home-manager 实际解密位置
  programs.pi-coding-agent.models.providers.deepseek.apiKey =
    "!cat ${config.age.secrets.deepseek-api-key.path}";

  programs.pi-coding-agent.models.providers.xiaomi.apiKey =
    "!cat ${config.age.secrets.mimo-api-key.path}";
}
