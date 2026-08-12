{
  inputs,
  ...
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
}
