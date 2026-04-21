{ ... }: {
  # 桌面环境剪贴板绑定（在 tui-base/programs/yazi.nix 的基础上追加）
  programs.yazi.keymap.mgr.prepend_keymap = [
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
