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
    ]
    ++ lib.optionals (pkgs.stdenv.hostPlatform.isLinux && hostProfile.graphical) [
      inputs.orca.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
}
