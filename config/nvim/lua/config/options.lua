-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.transparent_background = true
if vim.g.neovide then
  require("config.neovide").init()
end

if vim.g.vscode then
  require("config.vscode").init()
end

-- If using Neovim under SSH, using OSC52 to synchronous system clipboard.
-- In wsl, using clip.exe
vim.opt.clipboard:append("unnamedplus")

if vim.fn.exists("$SSH_TTY") == 1 and vim.env.TMUX == nil and vim.env.ZELLIJ == nil then
  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
      ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
      ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
      ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
    },
  }
elseif vim.fn.has("wsl") == 1 then
  ---@diagnostic disable-next-line: param-type-mismatch
  local script_folder = vim.fs.joinpath(vim.fn.stdpath("config"), "scripts")

  vim.g.clipboard = {
    name = "WslClipboard",
    copy = {
      -- WARN: clip.exe might produce garbled text under certain conditions
      -- ['+'] = 'clip.exe',
      -- ['*'] = 'clip.exe',
      ["+"] = "win32yank.exe -i",
      ["*"] = "win32yank.exe -i",
    },
    paste = {
      -- -- ['+'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      -- -- ['*'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      -- ['+'] = 'win32yank.exe --1f',
      -- ['*'] = 'win32yank.exe --1f',
      ["+"] = vim.fs.joinpath(script_folder, "wsl-paste.sh"),
      ["*"] = vim.fs.joinpath(script_folder, "wsl-paste.sh"),
    },
    cache_enabled = true,
  }
end
