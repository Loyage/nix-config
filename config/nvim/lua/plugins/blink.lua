-- 补全插件
return {
  {
    "saghen/blink.cmp",
    opts = {
      completion = {
        menu = {
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
          function()
            -- 如果接受 copilot 建议，自动将原输入设置为撤销前结果
            if require("copilot.suggestion").is_visible() then
              LazyVim.create_undo()
              require("copilot.suggestion").accept()
              return true
            end
          end,
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
