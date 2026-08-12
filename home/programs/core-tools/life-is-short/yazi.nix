{
  pkgs,
  lib,
  ...
}:
{
  programs.yazi = {
    enable = true;
    shellWrapperName = "y";
    plugins = with pkgs.yaziPlugins; {
      git = {
        package = git;
        setup = true;
      };
      full-border = {
        package = full-border;
        setup = true;
        settings = {
          type = lib.mkLuaInline "ui.Border.ROUNDED";
        };
      };
      chmod.package = chmod;
      ouch.package = ouch; # archives
      rsync.package = rsync;
    };
    initLua = ''
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
          on = [
            "c"
            "m"
          ];
          run = "plugin chmod";
          desc = "Chmod on selected files";
        }
        {
          on = [ "C" ];
          run = "plugin ouch";
          desc = "Compress with ouch";
        }
        {
          on = [ "R" ];
          run = "plugin rsync -- --remember";
          desc = "Copy files using rsync (remember target)";
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
          {
            id = "git";
            url = "*";
            run = "git";
            group = "git";
          }
          {
            id = "git";
            url = "*/";
            run = "git";
            group = "git";
          }
        ];
      };
    };
  };
}
