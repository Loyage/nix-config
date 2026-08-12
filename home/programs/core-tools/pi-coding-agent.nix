{ inputs
, ...
}:
{
  programs.pi-coding-agent = {
    enable = true;

    # pi 安装的插件所需的额外命令（如 npm、git 等）会追加到 pi 的 PATH。
    # pi-sidebar 纯 TS 无 npm 依赖，但保留 git 以备其他插件/工具使用。
    extraPackages = [ ];

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

      # 插件以本地路径（nix store）形式声明，构建时由 flake input 提供，
      # pi 启动时按 pi-package 规则从该目录收集 extensions/skills。
      packages = [
        "${inputs.pi-sidebar}"
      ];
    };
  };

  home.sessionVariables = {
    PI_SIDEBAR_WIDTH = "40"; # 内容列宽调宽一档，方便看完整文件路径
    PI_SIDEBAR_GIT_LINES = "15"; # 详细模式多显示几行变更文件
    PI_SIDEBAR_FULL_HEIGHT = "1"; # 1=全高固定窗口模式（非浮动）
  };
}
