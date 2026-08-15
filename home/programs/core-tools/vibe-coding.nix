{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    herdr
    opencode
    claude-code
    codex
    antigravity-cli
  ];
}
