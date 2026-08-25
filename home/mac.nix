{
  pkgs,
  inputs,
  config,
  ...
}:
{
  imports = [
    ./home-setting.nix
    ./programs/core-tools
    inputs.deepseek-harness-flake.homeModules.default
  ];

  # Maple Mono NF CN：neovide / kitty 使用的字体，home-manager 会同步到 ~/Library/Fonts/HomeManager
  home.packages = with pkgs; [
    maple-mono.NF-CN
    codexbar # api usage monitor
  ];

  # SSH 从 kitty 登录时 TERM=xterm-kitty；macOS 自带的 ncurses
  # 需要在 78/ 目录中查找该 terminfo（x 的十六进制目录名）。
  # kitty 在 Darwin 的 terminfo 位于 app bundle 内，不是 lib/kitty/terminfo。
  home.file.".terminfo/78/xterm-kitty".source =
    "${pkgs.kitty}/Applications/kitty.app/Contents/Resources/kitty/terminfo/78/xterm-kitty";
  home.sessionVariables.TERMINFO_DIRS = "${config.home.homeDirectory}/.terminfo:${pkgs.kitty}/Applications/kitty.app/Contents/Resources/kitty/terminfo:/usr/share/terminfo";

  # yazi on macOS: y 复制文件路径，Y 复制文件内容到剪贴板
  programs.yazi.keymap.mgr.prepend_keymap = [
    {
      on = "Y";
      run = [ "shell 'cat \"$@\" | pbcopy'" ];
      desc = "将文件内容复制到剪贴板 (macOS)";
    }
    {
      on = "o";
      run = [ "shell 'open .'" ];
      desc = "在 Finder 中打开当前目录 (macOS)";
    }
  ];
}
