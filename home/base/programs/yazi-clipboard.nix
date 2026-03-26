{ ... }: {
  # 桌面环境剪贴板绑定（在 terminal/programs/yazi.nix 的基础上追加）
  programs.yazi.keymap.mgr.prepend_keymap = [
    # macOS: 复制文件内容到剪贴板
    {
      on = "Y";
      run = [ "shell 'cat \"$@\" | pbcopy'" ];
      desc = "将文件内容复制到剪贴板 (macOS)";
    }
    # Linux Wayland: 复制选中文件路径到系统剪贴板
    {
      on = "y";
      for = "linux";
      run = [
        "shell -- for path in %s; do echo \"file://$path\"; done | wl-copy -t text/uri-list"
        "yank"
      ];
      desc = "Copy selected files to the system clipboard (Wayland)";
    }
  ];
}
