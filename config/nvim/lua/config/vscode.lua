local M = {}

local vscode = require("vscode")

function M.init()
  local set = vim.keymap.set

  set({ "n", "x" }, "<leader>wa", function()
    vscode.action("workbench.action.files.saveFiles")
  end)
end

return M
