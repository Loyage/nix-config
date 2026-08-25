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

      terminal = {
        showTerminalProgress = true;
      };

      # 绕过用户全局 ~/.npmrc 的 min-release-age=7（只拒绝 7 天内的新版本），
      # 否则 pi-web-access@0.22.0 等刚发布的插件会 npm install ETARGET。
      npmCommand = [
        "npm"
        "--min-release-age=0"
      ];

      # 插件声明：本地 store 路径（flake input，无 npm 依赖）或 npm 源（有依赖，pi 运行期安装）。
      # pi 启动时按 pi-package 规则从这些源收集 extensions/skills。
      packages = [
        "${inputs.pi-sidebar}"
        "${inputs.pi-codex-goal}"
        "${inputs.academic-research-skills}"
        "npm:pi-web-access@0.22.0"
        "npm:pi-usage-meters@0.1.0"
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

  home.sessionVariables = {
    PI_SIDEBAR_WIDTH = "40"; # 内容列宽调宽一档，方便看完整文件路径
    PI_SIDEBAR_GIT_LINES = "15"; # 详细模式多显示几行变更文件
    PI_SIDEBAR_FULL_HEIGHT = "1"; # 1=全高固定窗口模式（非浮动）
  };
}
