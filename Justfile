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
  sudo nixos-rebuild switch --flake . --show-trace

# 构建并切换 NixOS 配置 (使用测试通道)
[group('rebuild')]
[linux]
switch-test:
  sudo nixos-rebuild test --flake .#nixos

# 查看 NixOS generations
[group('rebuild')]
[linux]
generations:
  sudo nix-env -p /nix/var/nix/profiles/system --list-generations

# ─────────────────────────────────────────────────────────────────────────────
# Darwin (macOS) 构建和切换
# ─────────────────────────────────────────────────────────────────────────────

# 构建并切换 Darwin 配置
[group('rebuild')]
[macos]
switch:
  sudo darwin-rebuild switch --flake . --show-trace

# 查看 Darwin generations
[group('rebuild')]
[macos]
generations:
  nix-env -p /nix/var/nix/profiles/system --list-generations

# 清理旧的 Darwin generations
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
