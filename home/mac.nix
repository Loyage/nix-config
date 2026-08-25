{
  pkgs,
  inputs,
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
  # 不会自动搜索 Nix 安装的 kitty terminfo，放入用户默认搜索路径。
  home.file.".terminfo/x/xterm-kitty".source = "${pkgs.kitty}/lib/kitty/terminfo/x/xterm-kitty";

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
