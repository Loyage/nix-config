{
  inputs,
  lib,
  pkgs,
  hostProfile ? {
    graphical = true;
  },
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
    ++ lib.optionals (pkgs.stdenv.isLinux && hostProfile.graphical) [
      inputs.orca.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
}
