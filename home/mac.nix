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
