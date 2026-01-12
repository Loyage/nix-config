-- ufo关于折叠的设置
vim.o.foldcolumn = "0" -- '0' is not bad,其他的会有奇怪的数字
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

return {
  "kevinhwang91/nvim-ufo",
  dependencies = "kevinhwang91/promise-async",
  config = function()
    -- 控制折叠块后边显示什么
    local handler = function(virtText, lnum, endLnum, width, truncate)
      local newVirtText = {}
      local suffix = (" 󰁂 %d lines"):format(endLnum - lnum)
      local sufWidth = vim.fn.strdisplaywidth(suffix)
      local targetWidth = width - sufWidth
      local curWidth = 0
      for _, chunk in ipairs(virtText) do
        local chunkText = chunk[1]
        local chunkWidth = vim.fn.strdisplaywidth(chunkText)
        if targetWidth > curWidth + chunkWidth then
          table.insert(newVirtText, chunk)
        else
          chunkText = truncate(chunkText, targetWidth - curWidth)
          local hlGroup = chunk[2]
          table.insert(newVirtText, { chunkText, hlGroup })
          chunkWidth = vim.fn.strdisplaywidth(chunkText)
          -- str width returned from truncate() may less than 2nd argument, need padding
          if curWidth + chunkWidth < targetWidth then
            suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
          end
          break
        end
        curWidth = curWidth + chunkWidth
      end
      table.insert(newVirtText, { "  ◖", "@comment.warning.gitcommit" })
      table.insert(newVirtText, { suffix, "@comment.warning" })
      table.insert(newVirtText, { "◗  ", "@comment.warning.gitcommit" })
      return newVirtText
    end
    -- -- Option 2: nvim lsp as LSP client
    -- -- Tell the server the capability of foldingRange,
    -- -- Neovim hasn't added foldingRange to default capabilities, users must add it manually
    -- local capabilities = vim.lsp.protocol.make_client_capabilities()
    -- capabilities.textDocument.foldingRange = {
    --   dynamicRegistration = false,
    --   lineFoldingOnly = true,
    -- }
    -- local language_servers = vim.lsp.get_clients() -- or list servers manually like {'gopls', 'clangd'}
    -- for _, ls in ipairs(language_servers) do
    --   require("lspconfig")[ls].setup({
    --     capabilities = capabilities,
    --     -- you can add other fields for setting up lsp server in this table
    --   })
    -- end
    -- require("ufo").setup()
    -- Option 3: treesitter as a main provider instead
    -- Only depend on `nvim-treesitter/queries/filetype/folds.scm`,
    -- performance and stability are better than `foldmethod=nvim_treesitter#foldexpr()`
    require("ufo").setup({
      provider_selector = function(bufnr, filetype, buftype)
        return { "treesitter", "indent" }
      end,
      fold_virt_text_handler = handler,
    })
    -- 键盘映射,这里的按键会打开或折叠全部的可折叠位置
    vim.keymap.set("n", "zr", require("ufo").openAllFolds)
    vim.keymap.set("n", "zm", require("ufo").closeAllFolds)
  end,
}
