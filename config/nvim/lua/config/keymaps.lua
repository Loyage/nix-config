-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local del = vim.keymap.del
-- local set = vim.keymap.set
-- LazyVim.safe_keymap_set 会自动检查是否已经存在相同的映射，还会检查避免 vscode 模式下引入映射，
-- 因此推荐使用 LazyVim.safe_keymap_set 来设置映射。
local map = LazyVim.safe_keymap_set

-- 删除一些按键
del("n", "<C-Up>")
del("n", "<C-Down>")

-- `noremap = true`：表示非递归映射。即在映射中不会再进行二次映射，防止无限递归。
-- `silent = true`：表示执行映射时不显示命令行信息，保持安静。
map("i", "jk", "<Esc>", { noremap = true, silent = true })
map("i", "jj", "<Esc>:w<CR>", { noremap = true, silent = true })
map("n", "<leader>wa", ":wa<CR>", { desc = "Write All", noremap = true, silent = true })
map("n", "q", "<Nop>") -- 禁用 q 键宏录制
map("v", "q", "<ESC>")

-- Ctrl + A 全选
map("n", "<C-a>", "ggVG", { noremap = true, silent = true })
map("v", "<C-a>", "ggVG", { noremap = true, silent = true })
map("i", "<C-a>", "<Esc>ggVG", { noremap = true, silent = true })

-- Ctrl + C 复制
map("v", "<C-c>", '"+y', { noremap = true, silent = true })

-- Ctrl + V 粘贴
map("i", "<C-v>", '<C-r>"', { noremap = true, silent = true })
