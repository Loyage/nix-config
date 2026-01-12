-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- 全局禁用拼写检查
-- vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
-- 在 md，txt 中禁用拼写检查
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "txt" },
  callback = function()
    vim.opt_local.spell = false
  end,
})

-- 为 markdown、python 设置默认缩进空格数为 4
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "python" },
  callback = function()
    vim.opt_local.shiftwidth = 4
  end,
})

-- 设置退出 insert 模式时fcitx自动切换英文输入法
-- macos 下的输入法切换见 plugins/im-select.lua
vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = "*",
  callback = function()
    local fcitx5state = vim.fn.system("fcitx5-remote")[1]
    vim.fn.system("fcitx5-remote -c")
  end,
})
