{
  inputs,
  pkgs,
  lib,
  myvars,
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
        welcome = false;
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
        "${inputs.academic-research-skills}"
        "npm:pi-web-access@0.22.0"
        "npm:pi-context-view@0.5.0"
        "npm:pi-btw@0.4.1"
        "npm:@juicesharp/rpiv-ask-user-question@2.8.0"
        "npm:pi-dynamic-workflows@1.0.1"
        "npm:pi-plan-mode@0.4.8"
        "npm:pi-powerline-footer@0.16.0"
        "npm:@pi-orca/agents@0.0.5"
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

  # git-crypt 默认从每个 worktree 独立的 Git 目录读取 key，而 key 实际只存在于
  # 主仓库的 common Git 目录。让过滤器显式使用 common dir，避免 agents 创建
  # worktree 时因 smudge 找不到 key 而失败。
  home.activation.piAgentsGitCryptWorktree = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    repo="$HOME/${myvars.repositoryDirectory}"
    if ${pkgs.git}/bin/git -C "$repo" rev-parse --git-dir >/dev/null 2>&1; then
      ${pkgs.git}/bin/git -C "$repo" config --local filter.git-crypt.smudge \
        'GIT_DIR="$(git rev-parse --git-common-dir)" git-crypt smudge'
      ${pkgs.git}/bin/git -C "$repo" config --local filter.git-crypt.clean \
        'GIT_DIR="$(git rev-parse --git-common-dir)" git-crypt clean'
      ${pkgs.git}/bin/git -C "$repo" config --local diff.git-crypt.textconv \
        'GIT_DIR="$(git rev-parse --git-common-dir)" git-crypt diff'
    fi
  '';

  # @pi-orca/agents：声明式维护用户级子代理模板。
  # scout/planner 使用低开销 SDK；写入和审查代理使用独立进程，避免子代理故障影响主 Pi。
  # worktree 代理由插件自动分配独立 worktree/分支，适合显式要求隔离实施的任务。
  home.file =
    lib.mapAttrs' (name: text: lib.nameValuePair ".pi/agent/orca/agents/${name}.md" { inherit text; })
      {
        scout = ''
          ---
          name: scout
          description: 快速、只读的代码库探索与信息收集
          model: deepseek/deepseek-v4-flash
          thinking: minimal
          context: fresh
          tools: [read, grep, find, ls, bash]
          skills: []
          restrictions: []
          restrictionsMode: override
          isolation: sdk
          lifecycle: one-shot
          completionNotify: parent
          useWorktree: false
          labels:
            category: investigation
          ---

          # Scout Agent

          快速调查指定问题并返回简洁、可核验的结论。只读操作，不修改文件；引用具体文件路径和行号。
        '';

        planner = ''
          ---
          name: planner
          description: 分解复杂任务并制定依赖明确的实施计划
          model: openai-codex/gpt-5.6-sol
          thinking: high
          context: fresh
          tools: [read, grep, find, ls]
          skills: []
          restrictions: []
          restrictionsMode: override
          isolation: sdk
          lifecycle: one-shot
          completionNotify: parent
          useWorktree: false
          labels:
            category: planning
          ---

          # Planner Agent

          调查现有实现后制定具体计划。指出文件、符号、执行顺序、依赖、风险和验证步骤；只规划，不实施。
        '';

        worker = ''
          ---
          name: worker
          description: 按明确任务实施代码改动并进行验证
          model: openai-codex/gpt-5.6-sol
          thinking: medium
          context: fresh
          tools: [read, write, edit, grep, find, ls, bash]
          skills: []
          restrictions: []
          restrictionsMode: override
          isolation: process
          lifecycle: one-shot
          completionNotify: parent
          useWorktree: false
          labels:
            category: implementation
          ---

          # Worker Agent

          先阅读现有实现和项目约定，再完成指定改动并运行相关检查。不要扩大范围；报告改动、验证结果和遗留风险。
        '';

        worktree = ''
          ---
          name: worktree
          description: 在独立 Git worktree 和分支中实施代码改动
          model: openai-codex/gpt-5.6-sol
          thinking: medium
          context: fresh
          tools: [read, write, edit, grep, find, ls, bash]
          skills: []
          restrictions: []
          restrictionsMode: override
          isolation: process
          lifecycle: one-shot
          completionNotify: parent
          useWorktree: true
          labels:
            category: implementation
            workspace: worktree
          ---

          # Worktree Worker Agent

          你在插件自动创建的独立 Git worktree 和 `orca/...` 分支中工作。
          先阅读现有实现和项目约定，再完成指定改动并运行相关检查。
          不要扩大任务范围，不要推送远端。完成后提交全部相关改动，并报告分支名、提交哈希、验证结果和遗留风险，方便父代理审查后合并。
        '';

        reviewer = ''
          ---
          name: reviewer
          description: 只读审查代码的正确性、安全性和一致性
          model: openai-codex/gpt-5.6-sol
          thinking: high
          context: fresh
          tools: [read, grep, find, ls, bash]
          skills: []
          restrictions: []
          restrictionsMode: override
          isolation: process
          lifecycle: one-shot
          completionNotify: parent
          useWorktree: false
          labels:
            category: review
          ---

          # Reviewer Agent

          只读审查，不修改文件。按严重程度列出发现，并为每项提供文件路径、行号、影响和建议修复方式。
        '';
      };

  # rpiv-ask-user-question：控制模型何时通过结构化问答向用户确认决策。
  xdg.configFile."rpiv-ask-user-question/config.json".text = builtins.toJSON {
    guidance = {
      promptSnippet = "Ask the user before making a non-trivial decision when multiple reasonable choices exist.";
      promptGuidelines = [
        "Ask before making architecture, product behavior, UX, public API, or data-model decisions when the user's preference is unknown."
        "Do not ask about routine, low-impact, easily reversible implementation details."
        "Batch related decisions into one ask_user_question call when practical."
      ];
    };
  };
}
