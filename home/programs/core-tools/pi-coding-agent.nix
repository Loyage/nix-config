{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  programs.pi-coding-agent = {
    enable = true;

    # pi 安装的插件所需的额外命令（如 npm、git 等）会追加到 pi 的 PATH。
    # npm 源插件（pi-web-access）首次加载时需 npm install；
    # ffmpeg/yt-dlp 是 web-access 视频提取所需。
    extraPackages = [
      pkgs.nodejs # 提供 npm，pi 安装 npm 源插件时使用
      pkgs.git
      pkgs.ffmpeg # 视频帧提取、时长探测
      pkgs.yt-dlp # YouTube 流地址获取
    ];

    settings = {
      # lastChangelogVersion 由 pi 自动维护，这里声明以保持声明式一致
      lastChangelogVersion = "0.84.0";

      theme = "dark";
      defaultProvider = "openai-codex";
      defaultModel = "gpt-5.6-luna";
      defaultThinkingLevel = "medium";

      # pi-powerline-footer：状态栏、欢迎面板和快捷操作
      powerline = {
        preset = "default";
        placement = "below";
      };

      terminal = {
        showTerminalProgress = true;
      };

      # 绕过用户全局 ~/.npmrc 的 min-release-age=7（只拒绝 7 天内的新版本），
      # 否则 pi-web-access@0.22.0 等刚发布的插件会 npm install ETARGET。
      npmCommand = [
        "npm"
        "--min-release-age=0"
      ];

      # 插件声明：这里有意保留两种导入方式，不强行统一：
      # - 纯文件、无 npm 依赖的插件/技能使用 flake input：版本由 flake.lock 锁定，构建和离线使用更稳定；
      # - 依赖 npm 运行时安装的插件使用 npm 源：由 npm 处理依赖，维护方式更贴近上游发布方式。
      # pi 启动时按 pi-package 规则从这些源收集 extensions/skills。
      packages = [
        "${inputs.pi-codex-goal}"
        "${inputs.academic-research-skills}"
        "npm:pi-web-access@0.22.0"
        "npm:pi-subagents@0.56.0"
        "npm:pi-btw@0.4.1"
        "npm:pi-ask-me@0.1.1"
        "npm:pi-dynamic-workflows@1.0.1"
        "npm:pi-plan-mode@0.4.8"
        "npm:pi-powerline-footer@0.16.0"
      ];

    };

    # 自定义模型注册：必须用模块的顶层 `models` option，写入 ~/.pi/agent/models.json。
    # ⚠️ 不能放进 `settings`——pi 只从 models.json 读自定义 provider/apiKey，
    # settings.json 里的同名键会被静默忽略。
    # deepseek / xiaomi 都是 pi 内置 provider：只 override apiKey，内置模型（
    # deepseek-v4-*、mimo-v2.5 等）保留；apiKey 用 "!command" 语法在请求时执行
    # `cat` 读取 agenix 解密后的机密（/run/agenix/...，解密自 secrets/*.age）。
    # ⚠️ remote 服务器（standalone home-manager）的解密路径不同
    # （${XDG_RUNTIME_DIR}/agenix/...），由 home/remote-server.nix 覆盖此值。
    models = {
      providers.deepseek = {
        # mkDefault：NixOS/macOS 用系统级路径；remote 在 home/remote-server.nix 覆盖
        apiKey = lib.mkDefault "!cat /run/agenix/deepseek-api-key";
      };

      providers.xiaomi = {
        apiKey = lib.mkDefault "!cat /run/agenix/mimo-api-key";
      };
    };
  };

}
