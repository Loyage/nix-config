{ pkgs
, ...
}: {
  programs.yazi = {
    enable = true;
    flavors = {
      inherit (pkgs.yaziFlavors)
        catppuccin-mocha vscode-dark-plus vscode-light-plus;
    };
    theme = {
      flavor = {
        use = "catppuccin-mocha";
      };
    };
    plugins = {
      inherit (pkgs.yaziPlugins) full-border git chmod ouch;
    };
    initLua = ''
      require("git"):setup()
      require("full-border"):setup({
        -- Available values: ui.Border.PLAIN, ui.Border.ROUNDED
        type = ui.Border.ROUNDED,
      })
    '';
    keymap = {
      mgr.prepend_keymap = [
        # pbcopy
        {
          on = "Y";
          run = [
            "shell 'cat \"$@\" | pbcopy'"
          ];
          desc = "将文件内容复制到剪贴板";
        }
        # chmod
        {
          on = [ "c" "m" ];
          run = "plugin chmod";
          desc = "Chmod on selected files";
        }
        # ouch
        {
          on = [ "C" ];
          run = "plugin ouch";
          desc = "Compress with ouch";
        }
      ];
    };
    settings = {
      mgr = {
        ratio = [
          1
          3
          3
        ];
        show_hidden = true;
        sort_by = "natural";
        line_mode = "size";
      };
      plugin = {
        prepend_fetchers = [
          # git fetcher
          {
            id = "git";
            name = "*";
            run = "git";
          }
          {
            id = "git";
            name = "*/";
            run = "git";
          }
        ];
      };
    };
  };
}
