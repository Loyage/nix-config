--- snacks explorer 的相关快捷键
--- 出于个人喜好，<leader>e 和 <leader>E 已由 yazi 接管
--- 打开 explorer 的快捷键被映射为次级命令：<leader>fe, <leader>fE
return {
  {
    "folke/snacks.nvim",
    ---@type snacks.Config
    keys = {
      -- 开关隐藏文件
      -- ["<a-h>"] = { "toggle_hidden", mode = { "i", "n" } },
      {
        "<leader>e",
        false,
      },
      {
        "<leader>E",
        false,
      },

      -- 覆写 Smart Find 的快捷键，允许隐藏文件
      {
        "<leader><space>",
        function()
          Snacks.picker.smart({ hidden = true })
        end,
        desc = "Smart Find (allow hidden)",
      },
      {
        "<leader>/",
        function()
          Snacks.picker.grep()
        end,
        desc = "Grep",
      },
      {
        "<leader>:",
        function()
          Snacks.picker.command_history()
        end,
        desc = "Command History",
      },
      {
        "<leader>n",
        function()
          Snacks.picker.notifications()
        end,
        desc = "Notification History",
      },

      -- find
      {
        "<leader>fb",
        function()
          Snacks.picker.buffers()
        end,
        desc = "Buffers",
      },
      --- Config File: 其实就是 nvim 文件夹，单独设置一个快捷键可能是方便随时修改设置
      {
        "<leader>fc",
        function()
          Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
        end,
        desc = "Find Config File",
      },
      --- 感觉不如 smart find 一根
      {
        "<leader>ff",
        function()
          Snacks.picker.files()
        end,
        desc = "Find Files",
      },
      {
        "<leader>fg",
        function()
          Snacks.picker.git_files()
        end,
        desc = "Find Git Files",
      },
      {
        "<leader>fp",
        function()
          Snacks.picker.projects()
        end,
        desc = "Projects",
      },
      {
        "<leader>fr",
        function()
          Snacks.picker.recent()
        end,
        desc = "Recent",
      },
    },
  },
}
