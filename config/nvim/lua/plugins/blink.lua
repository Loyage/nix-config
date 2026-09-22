-- 补全插件
return {
  {
    "saghen/blink.cmp",
    opts = {
      completion = {
        menu = {
          -- Markdown 中不自动弹出补全建议，仍可手动触发补全
          auto_show = function()
            return vim.bo.filetype ~= "markdown"
          end,
          min_width = 7,
          border = "single",
          draw = {
            padding = 1,
            gap = 0,
            columns = { { "kind_icon" }, { "label", "kind", gap = 1 } },
          },
        },
        documentation = {
          window = { border = "rounded" },
        },
      },
      keymap = {
        preset = "super-tab",
        ["<CR>"] = { "accept", "fallback" },
        ["<Tab>"] = {
          "accept",
          "snippet_forward",
          "fallback",
        },
        -- Shift-Tab 用于关闭建议
        ["<S-Tab>"] = {
          "hide",
          "snippet_backward",
          "fallback",
        },
      },
    },
  },
}
