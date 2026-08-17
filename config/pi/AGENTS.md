# Global Agent Instructions

## Environment Setup

This machine uses **Nix** for all package management and system configuration.

- **Package installation**: Always use `nix` tools (e.g., `nix-env -i`, `nix-shell`, `nix profile install`)
- **System configuration**: NixOS configs are managed via `just switch` (see `~/nix-config/AGENTS.md` for details)
- **Do not use**: `apt`, `yum`, `brew`, `pip install -g`, `npm install -g`, or other package managers unless explicitly instructed

## Network & Proxy

If you encounter network issues (connection timeouts, DNS failures, SSL errors):

- **Proxy is available at**: `127.0.0.1:7897`
- **Set these environment variables**:
  ```bash
  export http_proxy=http://127.0.0.1:7897
  export https_proxy=http://127.0.0.1:7897
  export ALL_PROXY=socks5://127.0.0.1:7897
  ```
- **Proxy software**: Clash Verge Rev (mihomo core, Service Mode)
- **Config file**: `~/.local/share/io.github.clash-verge-rev.clash-verge-rev/clash-verge.yaml`

## Quick Reference

- **SSH port**: 2222 (non-standard)
- **Nix config repo**: `~/nix-config`
- **Shell**: Zsh
- **Window manager**: niri (Wayland)
