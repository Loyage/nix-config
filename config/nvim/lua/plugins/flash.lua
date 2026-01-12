-- 快速跳转和选中插件，主要绑定 s, S, f, F, t, T 等键
return {
  "folke/flash.nvim",
  event = "VeryLazy",
  vscode = true,
  opts = {
    label = {
      -- 指示符彩虹🌈底色
      rainbow = {
        enabled = true,
        shade = 5,
      },
    },
  },
}
