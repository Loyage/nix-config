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

      # 插件声明：本地 store 路径（flake input，无 npm 依赖）或 npm 源（有依赖，pi 运行期安装）。
      # pi 启动时按 pi-package 规则从这些源收集 extensions/skills。
      packages = [
        "${inputs.pi-sidebar}"
        "${inputs.pi-codex-goal}"
        "npm:pi-web-access@0.22.0"
        "npm:pi-vision-proxy@1.7.1"
      ];
    };
  };

  home.sessionVariables = {
    PI_SIDEBAR_WIDTH = "40"; # 内容列宽调宽一档，方便看完整文件路径
    PI_SIDEBAR_GIT_LINES = "15"; # 详细模式多显示几行变更文件
    PI_SIDEBAR_FULL_HEIGHT = "1"; # 1=全高固定窗口模式（非浮动）
  };
}
