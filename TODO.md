# Nix 配置改进 TODO

本文档记录配置审查中发现的改进项，供后续分批修改。每批修改完成后应单独验证并提交，避免同时改变过多系统行为。

## 修改原则

- 优先修复检查覆盖和安全问题，再处理可移植性与代码风格。
- 涉及 sudo、SSH、防火墙、Homebrew 清理行为时，修改前确认实际使用需求。
- 不要因为升级 nixpkgs 而修改 `system.stateVersion` 或 `home.stateVersion`；它们应保持首次安装时的版本。
- NixOS 部署使用 `path:.`；新增文件在正式部署前必须 `git add`。
- 推荐每阶段单独提交，并在目标平台实际验证。

## P0：提高检查覆盖率

- [x] 更新 `git-hooks.nix`
  - 将已产生弃用警告的 `nixfmt-rfc-style` 改为 `nixfmt`。
  - 保留 deadnix、行尾空白和文件末尾换行检查。
- [x] 修复当前格式问题
  - 运行 `just lint`。
  - 检查 formatter 的改动后再次运行，直到通过。
  - 注意 `config/nvim/lua/plugins/extras/snacks/dashboard.lua` 的 ASCII 图案尾部空格可能具有排版意义；必要时为该文件配置排除，而不是无条件删除。
- [ ] 改进 `just check`
  - 当前 `nix flake check` 只检查本机系统，macOS 会跳过 `x86_64-linux`。
  - 评估是否默认使用 `nix flake check --all-systems`，同时避免在 macOS 上构建 Linux derivation。
- [ ] 给实际系统配置增加检查 derivation
  - Darwin：检查 `darwinConfigurations.${myvars.macosHostname}.system`。
  - Headless Home Manager：分别在 `x86_64-linux`、`aarch64-linux` 检查对应的 `activationPackage`。
  - NixOS：在 Linux 主机或 Linux CI 中检查 `nixosConfigurations.nixos.config.system.build.toplevel`。
  - 不要只依赖 flake output 枚举；它不会保证所有模块和 activation package 都被完整求值。
- [ ] 考虑为 macOS 和 Linux 分别配置 CI
  - 各平台运行自身的 eval/build 检查。
  - CI 中确认 `vars/private.nix` 的处理方式，不应暴露解密后的敏感内容。

### P0 验证

```bash
just lint
nix flake check --all-systems --no-build --show-trace
nix eval --raw 'path:.#darwinConfigurations."LoyagedeMacBook-Air".system.drvPath' --impure
```

Linux/NixOS 目标机额外运行：

```bash
just headless-preflight headless
just switch-test
```

## P1：收紧安全权限和网络暴露

- [ ] 审查无密码 sudo：`modules/linux/system.nix`
  - 当前用户可以对 `ALL` 使用 `NOPASSWD`。
  - 决定是恢复 sudo 密码，还是只允许必要命令（例如 rebuild、systemctl 等）。
  - 修改前确保不会破坏无人值守部署或现有脚本。
- [ ] 审查 Nix trusted user：`modules/base/nix.nix`
  - `trusted-users` 等同于授予很高的系统权限。
  - 如果确实需要用户自定义 substituter 或构建设置，应明确记录原因；否则考虑移除。
- [ ] 收紧 Steam 防火墙：`modules/linux/default.nix`
  - 确认是否使用 Remote Play、Dedicated Server 和局域网传输。
  - 不运行专用服务器时关闭 `dedicatedServer.openFirewall`。
  - 最好将这些开关移动到 `hosts/local/`，按主机启用。
- [ ] 按主机拆分 SSH `authorizedKeys`
  - 当前所有机器共享 `myvars.authorizedKeys`。
  - 在 host-specific 配置中声明每台机器允许的密钥，缩小私钥泄漏后的影响范围。
- [ ] 改进 authorized_keys 写入方式：`home/programs/core-tools/ssh.nix`
  - 考虑使用 `install -m 600` 或先写临时文件再原子替换。
  - 保持文件 owner、目录权限和 sshd `StrictModes` 兼容。

### P1 验证

- 从另一个终端确认 SSH 公钥登录仍然有效，再关闭当前连接。
- 验证 SSH 端口仍为 `2222`（NixOS）或 `22`（macOS）。
- 使用 `sudo -l` 检查实际授权。
- 检查防火墙规则并测试需要的 Steam 功能。

## P1：控制 Homebrew 激活副作用

- [ ] 调整 `modules/macos/brew.nix`
  - 当前每次 rebuild 都执行 `autoUpdate = true`、`upgrade = true` 和 `cleanup = "zap"`。
  - 建议默认关闭自动更新和升级，避免 rebuild 引入未锁定的软件变化。
  - 确认是否保留 `cleanup = "zap"`；它可能删除未声明或手工安装的软件。
- [ ] 如仍需自动维护，增加独立的显式 Just recipe
  - 例如手动执行更新、升级和清理。
  - 不要把高副作用操作绑定到每次 `darwin-rebuild switch`。

### P1 验证

```bash
just switch
brew bundle check
brew list --formula
brew list --cask
```

修改 `cleanup` 前后都应保存软件列表并比较，避免误删。

## P2：消除硬编码并改善可移植性

- [ ] `modules/macos/system.nix`
  - 将 `system.primaryUser = "loyage"` 改为使用 `myvars.username`。
- [ ] `home/programs/linux-only/DE/kde.nix`
  - 将壁纸目录 `/home/loyage/Pictures/Wallpapers` 改为基于 `config.home.homeDirectory`。
- [ ] `home/programs/linux-only/DE/noctalia/shell.nix`
  - 将头像路径 `/home/loyage/nix-config/config/avater.png` 改为基于 Home Manager home directory 或统一变量。
- [ ] `flake.nix`
  - 重新设计 `localHostDir = /home/loyage/nix-config/hosts/local`。
  - 目标：保留 gitignored `hosts/local/` 和 `--impure` 的工作方式，同时不要绑定固定用户名。
  - 修改时必须分别测试 macOS 上“目录不存在”和 NixOS 上“目录存在”两种情况。
- [ ] 统一仓库根目录变量
  - 当前多个模块默认仓库位于 `${HOME}/nix-config`。
  - 如果这是有意约束，应集中定义并在 README 中说明；否则提供可覆盖的 host option。

## P2：修正或移除易误导命令

- [ ] 检查 `Justfile` 中的 `home-switch`
  - 当前运行 `home-manager switch --flake path:.`，但 flake 没有当前用户/主机名对应的 standalone `homeConfigurations`。
  - NixOS/macOS 的 Home Manager 已集成到系统 rebuild，优先考虑让该命令转发到 `just switch`，或直接移除。
- [ ] 检查 `home-switch`、`remote-*`、`headless-*` 是否存在重复入口
  - 保留兼容别名时，在 `just --list` 的说明中明确标记。
  - 新文档统一使用 `headless-*` 名称。

## P3：配置整洁与维护成本

- [ ] 处理 Statix 警告
  - 空 module pattern `{ ... }:` 可改成 `_: `。
  - 合并同一 attrset 的重复路径，例如 `onActivation.*`、`age.*`、`services.*`、`home.*`。
  - `lib/attrs.nix` 中能使用 `inherit` 的地方改用 `inherit`。
  - 这些主要是可读性调整，应与行为修改分开提交。
- [ ] 将 Statix 纳入 pre-commit 或 CI
  - 先清理现有警告，再启用强制检查，避免一次引入大量噪声。
- [ ] 审查 flake lock 重复依赖
  - 当前 lock graph 包含多个 nixpkgs 和 Home Manager 实例。
  - 检查 `deepseek-harness-flake`、`nix-openclaw` 等输入是否允许其 `nixpkgs`/`home-manager` 跟随顶层输入。
  - 不要仅为减少节点强制 `follows`；先确认上游版本兼容性。
- [ ] 评估 `allowUnfree = true`
  - 如需更严格的许可控制，改用 `allowUnfreePredicate` 明确列出软件。
  - GUI 和专有应用较多时，可以保留现状并记录原因。
- [ ] 统一 substituters
  - 对比 `flake.nix` 与 `modules/base/nix.nix` 中的镜像列表。
  - 确保目标系统始终包含官方 `https://cache.nixos.org` 作为回退。
  - 尽量只维护一份共享定义，避免镜像配置漂移。
- [ ] 清理 Git 临时对象
  - 当前仓库检测到一个小型临时 pack；确认没有 Git 操作正在运行后执行 `git gc`。

## 推荐实施顺序

1. 单独提交 formatter/hook 修复。
2. 增加平台检查和 CI，不改变系统行为。
3. 收紧 Steam 端口。
4. 根据实际偏好调整 sudo 和 trusted user。
5. 调整 Homebrew 激活策略。
6. 消除硬编码路径。
7. 修正 Justfile 命令。
8. 最后处理 Statix、依赖去重等维护性优化。

## 每批修改后的通用检查

```bash
git diff --check
just lint
nix flake check --all-systems --no-build --show-trace
```

在对应目标机继续执行：

```bash
# NixOS：先测试，不写入 boot 默认 generation
just switch-test

# macOS
just switch

# Headless Home Manager
just headless-preflight headless
just headless-switch
```

完成后人工确认：登录、SSH、sudo、网络、桌面会话、输入法、终端、Homebrew 应用和 agenix 机密读取均正常。
