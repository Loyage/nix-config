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
      -- 显示链接目标
      Status:children_add(function(self)
        local h = self._current.hovered
        if h and h.link_to then
          return " -> " .. tostring(h.link_to)
        else
          return ""
        end
      end, 3300, Status.LEFT)
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
        # Linux: Copy selected files to the system clipboard while yanking
        {
          on = "y";
          for = "linux";
          run = [
            "shell -- for path in %s; do echo \"file://$path\"; done | wl-copy -t text/uri-list"
            "yank"
          ];
          desc = "Copy selected files to the system clipboard";
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
