-- default settings:
-- https://www.lazyvim.org/extras/lang/nix
-- ~/.local/share/nvim/lazy/LazyVim/lua/lazyvim/plugins/extras/lang/nix.lua
--
-- default plugins:
-- nvim-treesitter, nvim-lspconfig, conform
return {
  --------- import default settings firstly -------
  { import = "lazyvim.plugins.extras.lang.nix" },
  --------- then take settings yourself -----------
  -- {
  --   "mason-org/mason.nvim",
  --   opts = function(_, opts)
  --     opts.ensure_installed = opts.ensure_installed or {}
  --     table.insert(opts.ensure_installed, "")
  --   end,
  -- }
  -- {
  --   "stevearc/conform.nvim",
  --   optional = true,
  --   opts = {
  --     formatters_by_ft = {
  --       nix = { "nixpkgs-fmt" },
  --     },
  --   },
  -- },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        nil_ls = {
          mason = false,
          settings = {
            ["nil"] = {
              formatting = {
                command = { "nixpkgs-fmt" },
              },
            },
          },
        },
      },
    },
  },
  -- Mason: 移除 nil 和 nixpkgs-fmt 以避免编译错误，因为它们已由 Nix 管理
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}

      -- 过滤掉 nil 和 nixpkgs-fmt
      if type(opts.ensure_installed) == "table" then
        opts.ensure_installed = vim.tbl_filter(function(v)
          return v ~= "nil" and v ~= "nixpkgs-fmt"
        end, opts.ensure_installed)
      end
      return opts
    end,
  },
}
