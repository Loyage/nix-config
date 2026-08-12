set shell := ["zsh", "-uc"]

# List all the just commands
default:
  @just --list

# ─────────────────────────────────────────────────────────────────────────────
# 依赖管理
# ─────────────────────────────────────────────────────────────────────────────

# 更新所有 flake 依赖
[group('flake')]
up:
  nix flake update --commit-lock-file

# 更新特定 flake 输入
[group('flake')]
update-input INPUT:
  nix flake update {{INPUT}}

# 查看 flake 依赖树
[group('flake')]
deps:
  nix flake metadata --json | jq '.locks.nodes | keys'

# ─────────────────────────────────────────────────────────────────────────────
# NixOS 构建和切换
# ─────────────────────────────────────────────────────────────────────────────

# 构建并切换 NixOS 配置
[group('rebuild')]
[linux]
switch:
  test -d hosts/local || (echo "hosts/local/ 不存在！请执行: cp -r hosts/local.example hosts/local" && exit 1)
  sudo nixos-rebuild switch --flake .#nixos --show-trace

# 构建并切换 NixOS 配置 (使用测试通道)
[group('rebuild')]
[linux]
switch-test:
  test -d hosts/local || (echo "hosts/local/ 不存在！请执行: cp -r hosts/local.example hosts/local" && exit 1)
  sudo nixos-rebuild test --flake .#nixos

[group('rebuild')]
[linux]
switch-proxy:
  test -d hosts/local || (echo "hosts/local/ 不存在！请执行: cp -r hosts/local.example hosts/local" && exit 1)
  sudo ALL_PROXY=http://127.0.0.1:7897 nixos-rebuild switch --flake .#nixos --show-trace

[group('rebuild')]
[linux]
switch-boot:
  test -d hosts/local || (echo "hosts/local/ 不存在！请执行: cp -r hosts/local.example hosts/local" && exit 1)
  sudo nixos-rebuild boot --flake .#nixos

# 查看 NixOS generations
[group('rebuild')]
[linux]
generations:
  sudo nix-env -p /nix/var/nix/profiles/system --list-generations

# ─────────────────────────────────────────────────────────────────────────────
# macOS 构建和切换
# ─────────────────────────────────────────────────────────────────────────────

# 构建并切换 macOS 配置
[group('rebuild')]
[macos]
switch:
  sudo darwin-rebuild switch --flake . --show-trace

# 查看 macOS generations
[group('rebuild')]
[macos]
generations:
  nix-env -p /nix/var/nix/profiles/system --list-generations

[group('rebuild')]
[macos]
switch-proxy:
  sudo ALL_PROXY=http://127.0.0.1:7897 darwin-rebuild switch --flake . --show-trace

# 清理旧的 macOS generations
[group('rebuild')]
[macos]
gc:
  sudo nix-collect-garbage --delete-older-than 7d

# ─────────────────────────────────────────────────────────────────────────────
# 系统清理和维护
# ─────────────────────────────────────────────────────────────────────────────

# 清理旧的 NixOS generations
[group('clean')]
[linux]
gc:
  sudo nix-collect-garbage --delete-older-than 7d

# 查看存储使用情况
[group('clean')]
[linux]
[macos]
storage:
  nix-store --gc --print-dead
  nix-store --gc --print-live

# 优化存储
[group('clean')]
[linux]
[macos]
optimize:
  nix-store --optimize

# 运行 pre-commit hooks（格式化 + 检查全部文件）
[group('clean')]
[linux]
[macos]
lint:
  nix develop -c pre-commit run --all-files

# 运行 nix flake check（评估所有配置 + 构建并运行 pre-commit 检查）
[group('clean')]
[linux]
[macos]
check:
  nix flake check

# 安装 git pre-commit hooks（进入 devShell 时也会自动安装）
[group('clean')]
[linux]
[macos]
hooks-install:
  nix develop -c pre-commit install

# ─────────────────────────────────────────────────────────────────────────────
# Home Manager
# ─────────────────────────────────────────────────────────────────────────────

# 构建并切换 Home Manager 配置 (NixOS)
[group('home')]
[linux]
[macos]
home-switch:
  home-manager switch --flake . --show-trace

# 查看 Home Manager generations
[group('home')]
[linux]
[macos]
home-generations:
  home-manager generations

# 清理旧的 Home Manager generations
[group('home')]
[linux]
[macos]
home-clean:
  home-manager remove-generations old

# ─────────────────────────────────────────────────────────────────────────────
# 远程服务器开发环境（Ubuntu/Debian via SSH）
# ─────────────────────────────────────────────────────────────────────────────

# 首次部署：通过 nix run 安装 home-manager 并激活配置（x86_64）
[group('remote')]
remote-init:
  nix run home-manager/master -- switch --flake .#remote --show-trace --impure -b backup

# 首次部署：aarch64 服务器（AWS Graviton、树莓派等）
[group('remote')]
remote-init-arm:
  nix run home-manager/master -- switch --flake .#remote-aarch64 --show-trace --impure -b backup

# 更新远程配置（已安装 home-manager 后使用）
[group('remote')]
remote-switch:
  home-manager switch --flake .#remote --show-trace --impure -b backup

# 更新远程配置（aarch64）
[group('remote')]
remote-switch-arm:
  home-manager switch --flake .#remote-aarch64 --show-trace --impure -b backup

# 查看远程 home-manager generations
[group('remote')]
remote-generations:
  home-manager generations

# 清理远程旧 generations 并回收空间
[group('remote')]
remote-clean:
  home-manager remove-generations old && nix-collect-garbage --delete-older-than 7d

# ─────────────────────────────────────────────────────────────────────────────
# 展示一个 nix flake 所提供的东西
[linux]
[macos]
show target:
  nix flake show {{target}}
