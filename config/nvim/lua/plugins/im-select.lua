-- macos 下的输入法切换
return {
  {
    "keaising/im-select.nvim",
    lazy = false,
    -- 限制只在 MacOS 下使用
    cond = vim.loop.os_uname().sysname == "Darwin",
    opts = {
      default_im_select = "com.apple.keylayout.ABC",
      default_command = "im-select",
      -- 进入 Insert 模式不需要切回上次退出时的输入法
      -- 个人习惯每次进入 Insert 没有缓存，从默认输入法开始
      -- 如果需要缓存，可以删除行，恢复默认
      set_previous_events = {},
    },
  },
}
