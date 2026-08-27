{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  home.packages =
    with pkgs;
    [
      herdr
      opencode
      claude-code
      codex
      antigravity-cli
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      inputs.orca.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
}
