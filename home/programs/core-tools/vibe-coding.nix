{ pkgs
, ...
}: {
  home.packages = with pkgs; [
    opencode
    claude-code
    codex
    antigravity-cli
  ];
}
