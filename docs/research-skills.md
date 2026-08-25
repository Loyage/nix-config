# Academic Research Skills (ARS) — Pi 插件

## 概述

[ARS](https://github.com/Imbad0202/academic-research-skills) 是一套学术研究技能套件，覆盖从文献调研到论文发表的全流程。通过 Nix flake input 以 `flake = false` 方式引入，版本锁定在 `flake.lock` 中。

## 安装方式

不在每台机器上手动 `pi install`，而是通过 Nix 声明式管理：

- `flake.nix` 声明 input（`flake = false`）
- `home/programs/core-tools/pi-coding-agent.nix` 的 `packages` 列表引用 `"${inputs.academic-research-skills}"`
- `just switch` 后写入 `~/.pi/agent/settings.json`，Pi 启动时自动加载

## 不用时不影响 Pi

Wrapper 默认关闭 ARS：

- 启动时 `arsActive = false`
- `before_agent_start` 钩子将 4 个 ARS skill 从系统提示词中剥离，模型看不到它们
- 只有显式调用 `/ars-*` 命令或 `/skill:*` 时才激活
- 同一会话内状态持久化（`/tree` 切换分支保持），新会话自动重置

## 可用命令

### 管线控制

| 命令 | 说明 |
|------|------|
| `/ars-pi-start` | 当前会话启用 ARS，后续自然语言提问自动匹配技能 |
| `/ars-pi-stop` | 当前会话关闭 ARS，恢复普通模式 |
| `/ars-pi-doctor` | 检查环境依赖（orchestration、web、Python、Pandoc、tectonic 等） |

### 研究与写作

| 命令 | 说明 |
|------|------|
| `/ars-plan` | 苏格拉底式对话，梳理论文结构 |
| `/ars-lit-review <topic>` | 文献综述 |
| `/ars-reviewer` | 多角度同行评审 |
| `/ars-full` | 完整 10 阶段管线 |

### 直接调用核心技能

```
/skill:deep-research          # 深度研究（8 种模式）
/skill:academic-paper         # 论文写作（11 种模式）
/skill:academic-paper-reviewer # 论文评审（6 种模式）
/skill:academic-pipeline      # 完整管线编排器
```

## Pi 降级说明

ARS 原生为 Claude Code 设计，Pi 下有几个已知限制：

- **无 agent 隔离/编排** — 多 agent 角色顺序执行（非并行），wrapper 会披露降级状态
- **Claude hooks 不运行** — `PreToolUse` 写保护等仅在提示词层面执行，`/ars-pi-doctor` 会报告
- **Web 检索** — 需要 Pi 侧安装了 web search 能力（如 `pi-web-access`），否则无法进行文献验证

## 更新

```bash
# 更新 ARS 到最新版本
cd ~/nix-config
nix flake update academic-research-skills
just switch

# 更新所有输入（含 ARS）
just up
```

## 卸载

1. `flake.nix` 中移除 `academic-research-skills` input
2. `pi-coding-agent.nix` 的 `packages` 中移除 `"${inputs.academic-research-skills}"`
3. `just switch`
