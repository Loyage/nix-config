{ inputs
, pkgs
, ...
}:
{
  programs.pi-coding-agent = {
    enable = true;

    # pi 安装的插件所需的额外命令（如 npm、git 等）会追加到 pi 的 PATH。
    # npm 源插件（pi-web-access / pi-vision-proxy）首次加载时需 npm install；
    # ffmpeg/yt-dlp 是 web-access 视频提取与 vision-proxy 视频分析所需。
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
      defaultProvider = "deepseek";
      defaultModel = "deepseek-v4-flash";
      defaultThinkingLevel = "high";

      terminal = {
        showTerminalProgress = true;
      };

      # 绕过用户全局 ~/.npmrc 的 min-release-age=7（只拒绝 7 天内的新版本），
      # 否则 pi-web-access@0.22.0 等刚发布的插件会 npm install ETARGET。
      npmCommand = [ "npm" "--min-release-age=0" ];

      # 插件声明：本地 store 路径（flake input，无 npm 依赖）或 npm 源（有依赖，pi 运行期安装）。
      # pi 启动时按 pi-package 规则从这些源收集 extensions/skills。
      packages = [
        "${inputs.pi-sidebar}"
        "${inputs.pi-codex-goal}"
        "npm:pi-web-access@0.22.0"
        "npm:pi-vision-proxy@1.7.1"
      ];

      # 自定义模型注册，写入 ~/.pi/agent/models.json。
      # moonshot (Kimi K3) 用作 pi-vision-proxy 识图模型（配合 PI_VISION_PROXY_MODEL）。
      # API key 待提供：填 provider.apiKey（明文，建议用 sops）或 pi 内 /login 存 auth.json。
      models = {
        providers.moonshot = {
          baseUrl = "https://api.moonshot.ai/v1";
          api = "openai-completions";
          models = [
            {
              id = "kimi-k3";
              name = "Kimi K3";
              reasoning = true; # K3 始终在 thinking 模式运行
              input = [ "text" "image" ];
              cost = {
                input = 3.0;
                output = 15.0;
                cacheRead = 0.3;
              };
              contextWindow = 1000000; # 1M token 上下文
            }
          ];
        };
      };
    };
  };

  home.sessionVariables = {
    PI_SIDEBAR_WIDTH = "40"; # 内容列宽调宽一档，方便看完整文件路径
    PI_SIDEBAR_GIT_LINES = "15"; # 详细模式多显示几行变更文件
    PI_SIDEBAR_FULL_HEIGHT = "1"; # 1=全高固定窗口模式（非浮动）

    # 识图模型：moonshot/kimi-k3（pi-vision-proxy 环境变量覆盖，优先级高于 slash 命令配置）
    PI_VISION_PROXY_MODEL = "moonshot/kimi-k3";
  };
}
