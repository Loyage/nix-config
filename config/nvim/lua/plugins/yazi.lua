-- Yazi: 一个文件浏览软件
return {
  {
    "mikavilpas/yazi.nvim",
    -- 禁用 neotree 对应快捷键，避免被占用
    dependencies = {
      "nvim-neo-tree/neo-tree.nvim",
      keys = {
        {
          "<leader>e",
          false,
        },
        {
          "<leader>E",
          false,
        },
      },
    },
    keys = {
      {
        "<leader>e",
        mode = { "n", "v" },
        "<cmd>Yazi<cr>",
        desc = "Yazi (here)",
      },
      {
        -- Open in the current working directory
        "<leader>E",
        "<cmd>Yazi cwd<cr>",
        desc = "Yazi (cwd)",
      },
      {
        "<c-up>",
        "<cmd>Yazi toggle<cr>",
        desc = "Resume the last yazi session",
      },
    },
    opts = {
      -- if you want to open yazi instead of netrw, see below for more info
      open_for_directories = false,
      keymaps = {
        show_help = "<f1>",
      },
    },
  },
}
