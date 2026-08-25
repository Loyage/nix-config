# 在新项目中启用科研 Skills

本仓库将科研相关的 Pi skills 放在：

```text
~/nix-config/config/research-skills/
```

该目录没有安装到全局 `~/.agents/skills/`，因此不会影响普通项目。要在一个新的科研项目中启用它们，请在项目根目录创建或修改 `.pi/settings.json`。

## 项目配置

如果项目还没有 `.pi/settings.json`，创建以下文件：

```json
{
  "skills": ["~/nix-config/config/research-skills"]
}
```

如果文件已经存在，请保留原有配置，只把路径追加到 `skills` 数组中。例如：

```json
{
  "theme": "dark",
  "skills": [
    "./.pi/skills",
    "~/nix-config/config/research-skills"
  ]
}
```

不要把科研 skills 加入全局 `~/.pi/agent/settings.json`，也不要放入 `~/nix-config/config/skills/`；后者会被 Home Manager 链接到全局 skill 目录。

## 启用和使用

在项目根目录启动 Pi：

```bash
cd /path/to/research-project
pi
```

首次使用项目级资源时，Pi 可能要求信任该项目。信任后执行：

```text
/reload
```

然后手动调用科研总入口：

```text
/skill:research-skills
```

总入口会根据当前任务读取 `config/research-skills/` 下相关的子 skill。科研 skills 默认设置了 `disable-model-invocation: true`，不会在启动时被模型自动调用。

## 给新项目 Agent 的配置指令

可以直接把下面的内容告诉新项目中的 Agent：

```text
请为当前项目启用 Loyage 的科研 Pi skills：

1. 检查项目根目录是否存在 .pi/settings.json。
2. 如果不存在，创建它；如果存在，保留已有配置并合并修改。
3. 将 ~/nix-config/config/research-skills 加入 JSON 的 skills 数组。
4. 不要修改全局 ~/.pi/agent/settings.json。
5. 不要把科研 skills 复制到 ~/.agents/skills/ 或 ~/nix-config/config/skills/。
6. 配置完成后提醒我重启 Pi，或在 Pi 中执行 /reload。
7. 使用科研能力前，通过 /skill:research-skills 手动启用科研 skills。
```

## 重要说明

- 项目配置文件应放在每个独立 Git 仓库的根目录下；Pi 不会跨越项目 Git 根目录搜索项目资源。
- `~/nix-config` 必须是本机 Nix 配置仓库的实际路径。
- `config/research-skills` 下的新文件需要加入 Git，之后 Nix flake 构建才能稳定看到它们：

  ```bash
  cd ~/nix-config
  git add config/research-skills
  ```

- Pi 仍可能注册子 skill 的 `/skill:<name>` 手动命令，但它们不会自动调用。推荐统一使用 `/skill:research-skills` 作为科研入口。
