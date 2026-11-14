{
  pkgs,
  mylib,
  hostProfile ? { graphical = true; },
  ...
}:
{
  # catppuccin 是 GUI 主题（求值会触发 whiskers 的 Rust 构建），
  # headless 无图形环境时跳过，但保留 eza / ohmyposh 等终端美化。
  imports = builtins.filter (module: hostProfile.graphical || module != ./catppuccin.nix) (mylib.scanPaths ./.);
  home.packages = with pkgs; [
    fastfetch
    vivid # generator for LS_COLORS
    chafa # image to ANSI/Unicode character art
  ];
  # cattpuccin.nix only work when pprograms.xxx is enabled
  programs.bat.enable = true;
}
