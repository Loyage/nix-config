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
```

Same `just switch` on macOS runs `darwin-rebuild switch --flake . --impure`; recipes are gated by `[linux]`/`[macos]` attributes.

## Must know

- **`--impure` is required for every build/switch.** `flake.nix` uses `builtins.getEnv` (`mkRemoteHome` reads `PWD` for `hosts/remote/host-user.nix`) and the absolute path `/home/loyage/nix-config/hosts/local`. Without `--impure`, `getEnv` returns `""` and remote host overrides silently vanish.
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
- `secrets/` — agenix encrypted `.age` files; public keys in `vars/default.nix`. Note: `secrets/secrets.nix` imports `(import <nixpkgs> {}).lib`, not the flake, so re-encrypt (`agenix -r`) needs the nixpkgs channel.
- `pkgs/` — custom derivations (currently only `fcitx5-vinput.nix`, commented out in overlays)

## Gotchas

- No automated tests. Validation flow: `just switch-test`, verify manually, then `just switch`.
- `flake.nix` overlays pin custom `qq` / `wechat` / `pnpm_11` builds with exact hashes — update the hash when bumping versions.
- Remote `hosts/remote/host-user.nix` forces `home.username`/`home.homeDirectory` from `USER`/`HOME` env, so run remote commands as the target user.
- Commit messages are short and descriptive; recent history uses `feat/fix(<scope>)` prefixes, lockfile bumps read `flake.lock: Update` (from `just up`), and occasional Chinese messages are intentional.
