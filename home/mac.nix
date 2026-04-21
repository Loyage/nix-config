_: {
  imports = [
    ./home-setting.nix
    ./programs/core-tools
  ];

  # yazi on macOS: y 复制文件内容到剪贴板
  programs.yazi.keymap.mgr.prepend_keymap = [
    {
      on = "y";
      run = [ "shell 'cat \"$@\" | pbcopy'" ];
      desc = "将文件内容复制到剪贴板 (macOS)";
    }
  ];
}
