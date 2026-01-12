-- default settings:
-- https://www.lazyvim.org/extras/lang/typescript
-- ~/.local/share/nvim/lazy/LazyVim/lua/lazyvim/plugins/extras/lang/typescript.lua
--
-- default plugins:
-- nvim-lspconfig, mason.nvim, mini.icons, (nvim-dap)
return {
  --------- import default settings firstly -------
  { import = "lazyvim.plugins.extras.lang.typescript" },
  --------- then take settings yourself -----------
  -- LSP config
  {
    "neovim/nvim-lspconfig",
    -- default keymaps
    -------------------------------------------------------------------
    -- gD         -> Goto Source Definition : 转到原始定义
    -------------------------------------------------------------------
    -- gR         -> File References        : 文件内所有声明
    -------------------------------------------------------------------
    -- <leader>co -> Organize Imports       : 整理 imports
    -------------------------------------------------------------------
    -- <leader>cM -> Add missing imports    : 添加缺失的 imports
    -------------------------------------------------------------------
    -- <leader>cu -> Remove unused imports  : 删除未使用的 imports
    -------------------------------------------------------------------
    -- <leader>cD -> Fix all diagnostics    : 修复所有诊断
    -------------------------------------------------------------------
    -- <leader>cV -> Select TS workspace version  : 选择 TS 工作区版本
    -------------------------------------------------------------------
  },
  -- Mason: 确保 js-debug-adapter 已安装
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      table.insert(opts.ensure_installed, "js-debug-adapter")
    end,
  },
  -- typescript 文件相关 icons，
  -- 默认 icons 已由 LazyExtra 插件定义，这里不用重复定义，仅作占位提示
  {
    "nvim-mini/mini.icons",
  },
}
