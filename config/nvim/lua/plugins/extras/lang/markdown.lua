-- default settings:
-- https://www.lazyvim.org/extras/lang/markdown
-- ~/.local/share/nvim/lazy/LazyVim/lua/lazyvim/plugins/extras/lang/markdown.lua
--
-- default plugins:
-- nvim-lspconfig, mason.nvim, markdown-preview.nvim, render-markdown.nvim
return {
  --------- import default settings firstly -------
  { import = "lazyvim.plugins.extras.lang.markdown" },
  --------- then take settings yourself -----------
  {
    "mason-org/mason.nvim",
    -- -- 不要默认安装 markdownlint-cli2 和 markdown-toc
    -- -- 此外还要设置 conform.nvim 不要默认调用这俩，否则会持续报错
    -- opts = function(_, opts)
    --   local function removeByValue(array, value)
    --     for i, v in ipairs(array) do
    --       if v == value then
    --         table.remove(array, i)
    --         return
    --       end
    --     end
    --   end
    --   opts.ensure_installed = opts.ensure_installed or {}
    --   removeByValue(opts.ensure_installed, "markdownlint-cli2")
    --   removeByValue(opts.ensure_installed, "markdown-toc")
    -- end,
  },
  -- CMDS: MarkdownPreviewToggle, MarkdownPreview, MarkdownPreviewStop
  -- KEYS: <leader>cp as MarkdownPreviewToggle
  -- WARNING: yarn needed
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && yarn install",
    cond = function()
      return vim.fn.executable("yarn") == 1
    end,
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
  },
  -- TO: 用于在nvim中实时预览，和 render-markdown.nvim 二选一
  -- CMDS: MarkliveToggle, ..Enable, ..Disable
  {
    "yelog/marklive.nvim",
    enable = false,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    lazy = true,
    ft = "markdown",
    opts = {},
  },
  -- TO: 辅助写有序/无序列表
  -- KEYS:
  --- NORMAL mode: <<, >>, 'gN' to restart numbers, <leader>x to toggle checkbox
  --- INSERT mode: <C-t>, <C-d>
  --- VISUAL mode: <, >
  {
    "bullets-vim/bullets.vim",
    config = function()
      vim.g.bullets_enabled_file_types = { "markdown", "text", "gitcommit", "scratch" }
    end,
  },
  -- TO: 辅助编写表格
  -- CMDS: TableModeToggle, ..Enable, ..Disable
  -- KEYS: <Leader>tm as TableModeToggle
  {
    "dhruvasagar/vim-table-mode",
    config = function()
      vim.cmd(
        [[
        augroup markdown_config
          autocmd!
          autocmd FileType markdown nnoremap <buffer> <M-s> :TableModeRealign<CR>
        augroup END
      ]],
        false
      )
      vim.g.table_mode_sort_map = "<leader>mts"
    end,
  },
}
