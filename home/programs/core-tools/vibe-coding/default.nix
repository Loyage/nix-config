{ pkgs
, mylib
, ...
}: {
  imports = mylib.scanPaths ./.;
  home.packages = with pkgs; [
    opencode
    claude-code
    codex
    gemini-cli
  ];
}
