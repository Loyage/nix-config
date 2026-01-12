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
}
