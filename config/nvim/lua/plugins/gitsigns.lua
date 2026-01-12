return {
  {
    "lewis6991/gitsigns.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- gitsigns yadm 插件
      {
        "purarue/gitsigns-yadm.nvim",
        ---@module 'gitsigns-yadm'
        ---@type GitsignsYadm.Config
        opts = {
          shell_timeout_ms = 1000,
        },
      },
    },
    opts = {
      -- yadm = { enable = enable },
      linehl = true,
      current_line_blame = true,
      _on_attach_pre = function(bufnr, callback)
        require("gitsigns-yadm").yadm_signs(callback, { bufnr = bufnr })
      end,
    },
  },
}
