--- snacks: 一个集合了多种小插件的插件，定义项参考：
--- https://github.com/folke/snacks.nvim/blob/main/docs/dashboard.md
--- > tips: "gx" to quicklt open link
--- 为方便查询浏览，将 dashboard 和快捷键设置放入单独文件保存
return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      explorer = { enabled = true },
      picker = {
        enabled = true,
        layout = {
          preset = "default",
        },
      },
      bigfile = { enabled = true },
      indent = {
        enabled = true,
        scope = {
          enabled = true,
          underline = true,
        },
        chunk = {
          enabled = true,
          char = {
            corner_top = "╭",
            corner_bottom = "╰",
          },
        },
      },
      input = { enabled = true },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      -- notifier setting
      notifier = {
        enabled = true,
        timeout = 5000,
      },
      styles = {
        notification = {
          -- 允许换行
          -- wo = { wrap = true }, -- Wrap notifications
        },
      },
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          -- Setup some globals for debugging (lazy-loaded)
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end
          vim.print = _G.dd -- Override print to use snacks for `:=` command

          -- 一些开关快捷键
          -- us: 拼写检查
          Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
          -- uw: 过长自动换行
          Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
          -- uL: 相对行号
          Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
          -- ud: 诊断信息
          Snacks.toggle.diagnostics():map("<leader>ud")
          -- ul: 行号
          Snacks.toggle.line_number():map("<leader>ul")
          -- uc: ?
          Snacks.toggle
            .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
            :map("<leader>uc")
          -- uT: treesitter 高亮
          Snacks.toggle.treesitter():map("<leader>uT")
          -- ub: 黑暗背景
          Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
          -- uh: 行内类型注释
          Snacks.toggle.inlay_hints():map("<leader>uh")
          -- ug: 缩进提示
          Snacks.toggle.indent():map("<leader>ug")
          -- uD: 专注模式（只高亮当前所在块）
          Snacks.toggle.dim():map("<leader>uD")
        end,
      })
    end,
  },
  { import = "plugins/extras/snacks" },
}
