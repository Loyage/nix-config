# 使用全局科研 Skills

本仓库将科研相关的 Pi skills 放在：

```text
~/nix-config/config/research-skills/
```

Home Manager 会把整个目录链接到：

```text
~/.agents/skills/research-skills
```

因此科研 skills 在所有项目中都可被 Pi 发现，但它们都设置了
`disable-model-invocation: true`，不会自动进入上下文。

## 启用全局科研环境

确认 `~/nix-config/config/research-skills` 中的文件已经加入 Git，然后执行：

```bash
cd ~/nix-config
git add config/research-skills
home-manager switch --flake . --show-trace
```

也可以使用仓库中的快捷命令：

```bash
just home-switch
```

当前 Home Manager 配置会将科研 skill 集合安装到全局 Pi skill 目录，不需要在每个科研项目中创建 `.pi/settings.json`。

## 在 Pi 中手动启用

普通启动 Pi 时，科研 skills 不会影响 system prompt。需要使用科研能力时，手动输入：

```text
/skill:research-skill
```

入口 skill 会根据当前任务读取 `config/research-skills/` 下相关的子 skill 及其 references、assets 和 scripts。

如果 Pi 已经在运行，配置更新后执行：

```text
/reload
```

## 给新项目 Agent 的配置指令

科研环境已经由 Home Manager 全局安装。可以直接把下面的内容告诉新项目中的 Agent：

```text
科研 Pi skills 已通过 Home Manager 全局安装。

默认不要主动读取或调用科研 skills，也不要修改项目的 .pi/settings.json。
只有当我明确输入 /skill:research-skill 后，才启用科研 skill 集合；启用后根据当前任务读取相关子 skill 的 SKILL.md、references、assets 和 scripts。
```

## 重要说明

- `~/nix-config` 必须是本机 Nix 配置仓库的实际路径。
- `config/research-skills` 下的新文件需要加入 Git，否则 Nix flake 可能看不到它们。
- 子 skill 仍可能注册 `/skill:<name>` 手动命令，但不会自动调用；推荐统一使用 `/skill:research-skill` 作为入口。
- `disable-model-invocation` 只阻止自动注入，不会禁止用户手动调用子 skill。
