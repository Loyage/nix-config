_: {
  imports = [
    ./home-setting.nix
    ./programs/core-tools
  ];

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
