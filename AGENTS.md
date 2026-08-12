# AGENTS.md

Cross-platform Nix Flake config: NixOS (x86_64-linux), nix-darwin (aarch64-darwin), and standalone home-manager for remote Linux servers.

## Commands (full list in Justfile)

```bash
just switch                # NixOS: sudo nixos-rebuild switch --flake .#nixos --impure --show-trace
just switch-test           # apply config without changing boot entry
just switch-boot           # apply on next boot only
just up                    # nix flake update --commit-lock-file (commits "flake.lock: Update")
just update-input <name>   # update a single input
just home-switch           # home-manager switch --flake . --show-trace
just remote-init           # first-time server deploy (x86_64); remote-init-arm for aarch64
just remote-switch         # reapply server config after HM installed
just gc / just optimize    # cleanup
just lint                  # run pre-commit hooks on all files
just hooks-install         # install git pre-commit hooks
```

Same `just switch` on macOS runs `darwin-rebuild switch --flake . --impure`; recipes are gated by `[linux]`/`[macos]` attributes.

## Must know

- **`--impure` 已非必需（除 remote 部署）**。`flake.nix` 不再使用 `builtins.getEnv`（`mkRemoteHome` 通过 `self` 引用已跟踪的 `hosts/remote/host-user.nix`）；NixOS/macOS 命令已移除 `--impure`。仅 `hosts/remote/host-user.nix` 仍用 `getEnv "USER"/"HOME"`，且带 `mkIf` 非空守卫（纯模式下返回 "" 时优雅降级到 home-manager 默认值），因此 remote 部署建议保留 `--impure` 以获取真实用户信息。
- **`hosts/local/` is gitignored and mandatory.** To set up a machine: `cp -r hosts/local.example hosts/local`, then edit `host-user.nix` (hostname, GRUB dual-boot UUIDs, resume device). `flake.nix` `throw`s during eval if it's missing. This is where the NixOS hostname comes from — it is not set anywhere in the flake.
- **`config/` dirs are symlinked at build time** with `config.lib.file.mkOutOfStoreSymlink` from `${HOME}/nix-config/config` (hardcoded in `home/programs/core-tools/default.nix`, `home/programs/linux-only/DE/default.nix`, `home/home-setting.nix`, fcitx5). The repo must be checked out at `~/nix-config` on every target machine or those symlinks break.
- **`mylib.scanPaths` auto-imports** every `.nix` file and subdirectory of a dir, excluding `default.nix` (see `lib/default.nix`). Adding `home/programs/<layer>/<name>.nix` or a module file picks it up automatically; import order is alphabetical.
- **`specialArgs`** = `{ inputs, myvars, mylib }` is injected into every module. Prefer `myvars` (username `loyage`, keys, hostnames in `vars/default.nix`) over hardcoded values.

## Structure

- `modules/base` — cross-platform system modules (nix, agenix secrets, shell-tools)
- `modules/linux`, `modules/macos` — platform system config; `modules/optional` — desktop/dev opt-ins
- `home/programs/core-tools` — shared HM layer (imported by nixos/mac/remote entries)
- `home/programs/linux-only` — NixOS-only HM (DE/niri/noctalia, fcitx5, etc.), subdirs scanPath'd too
- `home/{nixos,mac,remote-server}.nix` — per-platform HM entrypoints
- `hosts/local{,example}/`, `hosts/remote/` — machine-specific overrides
- `secrets/` — agenix encrypted `.age` files; public keys in `vars/default.nix`. `secrets/secrets.nix` is pure (imports `../vars` directly, no `<nixpkgs>` channel), so `agenix -r` works without a nixpkgs channel.
- `pkgs/` — custom derivations (currently only `fcitx5-vinput.nix`, commented out in overlays)
- `git-hooks.nix` — pre-commit hooks config (nixfmt-rfc-style, deadnix, trim-trailing-whitespace, end-of-file-fixer)

## Pre-commit hooks

- Hooks defined in `git-hooks.nix`, exposed via `checks.<system>.pre-commit-check` and `devShells.<system>.default`.
- `just lint` runs all hooks on all files (`nix develop -c pre-commit run --all-files`).
- `just hooks-install` installs the git hook (also auto-installed when entering `nix develop`).
- `nix flake check` works on the NixOS machine (needs `hosts/local/`); on macOS it fails at `nixosConfigurations` because `hosts/local/` is Linux-only — use `just lint` there instead.

## Gotchas

- No automated tests. Validation flow: `just switch-test`, verify manually, then `just switch`.
- `flake.nix` overlays pin custom `qq` / `wechat` / `pnpm_11` builds with exact hashes — update the hash when bumping versions.
- Remote `hosts/remote/host-user.nix` forces `home.username`/`home.homeDirectory` from `USER`/`HOME` env, so run remote commands as the target user.
- Commit messages are short and descriptive; recent history uses `feat/fix(<scope>)` prefixes, lockfile bumps read `flake.lock: Update` (from `just up`), and occasional Chinese messages are intentional.
