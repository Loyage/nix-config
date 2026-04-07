{ pkgs, ... }: {
  programs.yazi = {
    enable = true;
    shellWrapperName = "y";
    plugins = {
      inherit (pkgs.yaziPlugins) full-border git chmod ouch;
    };
    initLua = ''
      require("git"):setup()
      require("full-border"):setup({
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
        {
          on = [ "c" "m" ];
          run = "plugin chmod";
          desc = "Chmod on selected files";
        }
        {
          on = [ "C" ];
          run = "plugin ouch";
          desc = "Compress with ouch";
        }
      ];
    };
    settings = {
      mgr = {
        ratio = [ 1 3 3 ];
        show_hidden = true;
        sort_by = "natural";
        line_mode = "size";
      };
      plugin = {
        prepend_fetchers = [
          { id = "git"; name = "*"; run = "git"; }
          { id = "git"; name = "*/"; run = "git"; }
        ];
      };
    };
  };
}
