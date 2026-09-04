{
  pkgs,
  config,
  ...
}:
{
  imports = [
    ./home-setting.nix
    ./programs/core-tools
  ];

  home = {
    # Maple Mono NF CN：neovide / kitty 使用的字体。
    packages = with pkgs; [
      maple-mono.NF-CN
      codexbar
    ];

    # macOS 自带 ncurses 需要 xterm-kitty 的十六进制目录条目。
    file.".terminfo/78/xterm-kitty".source =
      "${pkgs.kitty}/Applications/kitty.app/Contents/Resources/kitty/terminfo/78/xterm-kitty";
    sessionVariables.TERMINFO_DIRS = "${config.home.homeDirectory}/.terminfo:${pkgs.kitty}/Applications/kitty.app/Contents/Resources/kitty/terminfo:/usr/share/terminfo";
  };

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
