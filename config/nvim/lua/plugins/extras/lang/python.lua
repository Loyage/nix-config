-- default settings:
-- https://www.lazyvim.org/extras/lang/python
-- ~/.local/share/nvim/lazy/LazyVim/lua/lazyvim/plugins/extras/lang/python.lua
--
-- default plugins:
-- ..., neotest, nvim-dap-python
return {
  --------- import default settings firstly -------
  { import = "lazyvim.plugins.extras.lang.python" },
  --------- then take settings yourself -----------
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          mason = false,
          autostart = false,
        },
      },
    },
  },
}
