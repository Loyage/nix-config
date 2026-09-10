{ config, ... }:
{
  imports = [
    ./home-setting.nix
    ./programs/core-tools
  ];

  # 非 NixOS 的普通 Linux：让 home-manager 负责把 nix.sh / hm-session-vars.sh
  # 注入 shell。否则 ~/.bashrc、~/.profile 被 HM 接管后，Nix 安装器写入的
  # PATH 钩子会丢失，~/.nix-profile/bin（eza、nvim、nix…）全部不可见。
  targets.genericLinux.enable = true;

  # agenix 机密：pi provider 凭据（standalone home-manager 级）
  # 与 NixOS/macOS 的系统级定义（modules/base/secrets.nix）等价，
  # 但 home-manager 的解密路径是 ${XDG_RUNTIME_DIR}/agenix/...（运行时展开），
  # 而不是系统级的 /run/agenix/...。
  age.secrets = {
    deepseek-api-key = {
      file = ../secrets/deepseek-api-key.age;
      mode = "0400";
    };

    mimo-api-key = {
      file = ../secrets/mimo-api-key.age;
      mode = "0400";
    };

    github-copilot-auth = {
      file = ../secrets/github-copilot-auth.age;
      mode = "0400";
    };
  };

  # remote 上覆盖 pi 的 apiKey 路径，指向 home-manager 实际解密位置
  programs.pi-coding-agent.models.providers.deepseek.apiKey =
    "!cat ${config.age.secrets.deepseek-api-key.path}";

  programs.pi-coding-agent.models.providers.xiaomi.apiKey =
    "!cat ${config.age.secrets.mimo-api-key.path}";
}
