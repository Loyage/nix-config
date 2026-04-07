# Nix Configuration (nix-config) - Project Context

This is a comprehensive, cross-platform Nix configuration project based on Nix Flakes and Home Manager. It supports NixOS, nix-darwin (macOS), and standalone Home Manager deployments on remote Linux servers.

## Project Overview

- **Core Technologies:** Nix, Nix Flakes, Home Manager, nix-darwin.
- **Supported Architectures:** x86_64-linux, aarch64-linux, aarch64-darwin.
- **Design Philosophy:** Modular, hierarchical, and DRY (Don't Repeat Yourself).
- **Automation:** Uses a custom `scanPaths` function in `lib/default.nix` to automatically import all `.nix` files within a directory (excluding `default.nix`).

## Directory Structure & Architecture

### Hierarchy Logic
```text
remote  ──────────────────────→  tui-base
linux   →  gui-base  ─────────────→  tui-base
macos   →  gui-base  ─────────────→  tui-base
```

### Key Directories
- `flake.nix`: Main entry point for all system and home configurations.
- `vars/`: Global variables like `username`, `useremail`, and host definitions.
- `lib/`: Helper functions, including the automatic path scanner.
- `modules/`: System-level modules for NixOS and nix-darwin.
- `home/`: User-level Home Manager configurations.
  - `tui-base/`: Foundation for all environments (CLI tools, Shell, Editor).
  - `gui-base/`: GUI tools and common desktop configurations.
  - `linux/` / `macos/` / `remote/`: Platform-specific overlays.
- `config/`: Symlinked configuration files for tools like Neovim, Hyprland, Kitty, etc.
- `pkgs/`: Custom Nix derivations and overlays.
- `hosts/`: Hardware-specific configurations (e.g., `hardware-configuration.nix`).

## Building and Running

Common operations are managed via `just` (see `Justfile`).

### Common Commands
- **NixOS (Legion/ThinkPad):** `just switch` (rebuilds and switches the system configuration).
- **macOS:** `just switch` (rebuilds and switches the macOS configuration).
- **Remote Servers:**
  - Initial: `just remote-init` (x86_64) or `just remote-init-arm` (aarch64).
  - Update: `just remote-switch` or `just remote-switch-arm`.
- **Maintenance:**
  - Update Flake: `just up`.
  - Garbage Collection: `just gc`.
  - Optimize Store: `just optimize`.

## Development Conventions

### 1. Automatic Module Discovery
When adding a new Nix file to a directory that is processed by `mylib.scanPaths ./.`, it will be **automatically imported**. You do not need to manually add it to the `imports` list in `default.nix` unless you want to exclude it or need specific ordering.

### 2. Variable Usage
Always prefer using variables from `vars/` (e.g., `myvars.username`) instead of hardcoding strings to ensure consistency across all platforms.

### 3. Home Manager Configuration
Most user-specific software and configurations should be placed in `home/`. 
- Use `home.packages` for simple binary installations.
- Use specific modules (e.g., `programs.zsh`) for complex configurations.
- Use `config.lib.file.mkOutOfStoreSymlink` for linking configurations that need to be mutable or are part of the `config/` directory.

### 4. Custom Packages & Overlays
Custom packages go into `pkgs/` and are typically integrated via overlays in `flake.nix`.

## Key Files & Insights
- `flake.nix`: Manages inputs (nixpkgs-unstable, home-manager, etc.) and orchestrates the outputs for different hosts.
- `home/linux/programs/fcitx5.nix`: Example of a complex module with specific addon overrides and symlinks.
- `lib/default.nix`: Contains the logic for `scanPaths`, which is central to the project's modularity.
