local M = {}

function M.init()
  M.config()
  if vim.g.transparent_background then
    M.backgroud()
  end
  vim.g.nevide_refresh_rate = 60
end

function M.config()
  vim.o.guifont = "Maple Mono NF CN:h18"
  vim.g.neovide_cursor_vfx_mode = "railgun"
  vim.g.neovide_no_idle = true
  vim.g.neovide_title_background_color =
    string.format("%x", vim.api.nvim_get_hl(0, { id = vim.api.nvim_get_hl_id_by_name("Normal") }).bg)

  vim.g.neovide_title_text_color = "pink"
  vim.g.neovide_window_blurred = true -- macos only
  vim.g.neovide_confirm_quit = true
end

function M.backgroud()
  local alpha = function()
    return string.format("%x", math.floor((255 * vim.g.transparency) or 0.8))
  end

  vim.g.neovide_opacity = 0.9
  vim.g.neovide_normal_opacity = 0.4
  vim.g.transparency = 0.1
  -- vim.g.neovide_background_color = "#0f1117" .. alpha()
  vim.g.neovide_background_color = "#48bbe2" .. alpha()
end

return M
