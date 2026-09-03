# 配置维护与安全注意事项

本文记录日常使用中需要特别注意的行为和验证步骤。

## 仓库路径与求值模式

- 仓库默认位于 `$HOME/nix-config`；其他位置需设置
  `NIX_CONFIG_ROOT=/绝对路径`。
- NixOS 的 `hosts/local/` 被 Git 忽略，部署必须使用 `path:.` 和
  `--impure`，否则本机配置可能不会参与求值。
- 新增 Nix 文件后应先 `git add`，再执行正式部署，确保其他机器拉取后不会缺文件。

## 推荐验证流程

```bash
just lint
just check
```

`just check` 会求值全部平台，但只构建当前平台的完整系统或 Home Manager
activation derivation，避免 macOS 尝试构建 Linux derivation。

部署时继续执行对应平台的测试：

```bash
# NixOS：不改变默认 boot generation
just switch-test

# macOS
just switch

# Standalone Home Manager
just headless-preflight headless
just headless-switch
```

## SSH authorized_keys

`home/programs/core-tools/ssh.nix` 会原子写入 `~/.ssh/authorized_keys`，并设置
`~/.ssh` 为 `0700`、文件为 `0600`。

新主机默认仍回退到 `vars/public.nix` 的兼容密钥列表，以免迁移时锁死。应在
`hosts/local/host-user.nix` 中覆盖：

```nix
home-manager.users.${myvars.username}.localConfig.authorizedKeys = [
  "ssh-ed25519 AAAA..."
];
```

缩小密钥列表后，先从另一个终端确认公钥登录成功，再关闭现有 SSH 会话。NixOS
默认 SSH 端口为 `2222`，macOS 内置 sshd 仍监听 `22`。

## 权限与网络策略

- 个人工作站有意保留 `NOPASSWD: ALL` 与 Nix `trusted-users`。两者都近似授予
  root 权限，不应直接用于不受信任的多用户主机。
- Steam Remote Play、Dedicated Server 和局域网传输的防火墙开关默认关闭。
  需要时只在 `hosts/local/` 中按主机开启。
- `allowUnfree = true` 因 Steam、专有 GUI 软件和字体而保留；严格服务器环境应改为
  `allowUnfreePredicate` allowlist。

## Homebrew

`darwin-rebuild` 不再自动更新、升级或执行 `cleanup = "zap"`，避免一次 rebuild
引入未锁定变化或删除手工安装的软件。需要维护时显式运行：

```bash
just brew-maintain
```

维护前后可使用以下命令保存并比较软件列表：

```bash
brew list --formula
brew list --cask
brew bundle check
```

## CI 与私有变量

CI 不持有 git-crypt 密钥。工作流会在 checkout 后将加密的 `vars/private.nix`
替换为仅包含空 `sshHosts` 的临时配置，再执行求值和构建。不要在 CI 日志、artifact
或 workflow 中加入解密密钥；API key、token、密码和私钥必须继续使用 agenix。
