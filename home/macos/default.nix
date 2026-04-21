{ lib, mylib, myvars, ... }: {
  home = {
    inherit (myvars) username;
    homeDirectory = lib.mkForce "/Users/${myvars.username}";
    stateVersion = "25.11";
  };

  programs.home-manager.enable = true;

  imports = (mylib.scanPaths ./.) ++ [
    ../programs/core-tools
    ../gui-base
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
