return {
  -- 颜色原位显示
  {
    "NvChad/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({
        user_default_options = {
          RGB = true, -- Enable RGB color codes
          RRGGBB = true, -- Enable RRGGBB color codes
          names = true, -- Enable color names
          RRGGBBAA = true, -- Enable RRGGBBAA color codes
          rgb_fn = true, -- Enable rgb() and rgba() functions
          hsl_fn = true, -- Enable hsl() and hsla() functions
          css = true, -- Enable CSS color codes
          css_fn = true, -- Enable CSS functions
        },
      })
    end,
  },

  -- 🌈括号
  {
    "HiPhish/rainbow-delimiters.nvim",
    config = function()
      require("rainbow-delimiters.setup").setup({
        highlight = {
          "RainbowDelimiterBlue",
          "RainbowDelimiterViolet",
          "RainbowDelimiterRed",
          "RainbowDelimiterYellow",
          "RainbowDelimiterGreen",
          "RainbowDelimiterOrange",
          "RainbowDelimiterCyan",
        },
      })
    end,
  },
}
