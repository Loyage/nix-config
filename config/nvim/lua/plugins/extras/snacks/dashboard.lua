--- 自定义 dashboard
return {
  {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
      dashboard = {
        enabled = true,
        preset = {
          -- ASCII WordArt
          -- generate from: https://patorjk.com/software/taag
          -- font: ANSI Shadow
          header = [[

██╗      ██████╗ ███████╗██╗   ██╗ █████╗  ██████╗ ███████╗
██║     ██╔═══██╗╚══███╔╝╚██╗ ██╔╝██╔══██╗██╔════╝ ██╔════╝
██║     ██║   ██║  ███╔╝  ╚████╔╝ ███████║██║  ███╗█████╗  
██║     ██║   ██║ ███╔╝    ╚██╔╝  ██╔══██║██║   ██║██╔══╝  
███████╗╚██████╔╝███████╗   ██║   ██║  ██║╚██████╔╝███████╗
╚══════╝ ╚═════╝ ╚══════╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ╚══════╝
]],
        },
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          { section = "startup" },
          -- Avater:
          { height = 1, pane = 2, section = "terminal", cmd = "echo ' '" },
          {
            section = "terminal",
            pane = 2,
            -- https://github.com/TheZoraiz/ascii-image-converter
            -- cmd = "ascii-image-converter 'https://avatars.githubusercontent.com/u/55688916?v=4' -C -c",
            -- https://github.com/hpjansson/chafa
            cmd = "chafa ~/.config/avater.png --format symbols --symbols vhalf --size 40x40 ; sleep .1",
            indent = 12,
            height = 20,
          },
          { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
          { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
          {
            pane = 2,
            icon = " ",
            title = "Git Status",
            section = "terminal",
            enabled = function()
              return Snacks.git.get_root() ~= nil
            end,
            cmd = "git status --short --branch --renames",
            height = 5,
            padding = 1,
            ttl = 5 * 60,
            indent = 3,
          },
        },
      },
    },
  },
}
