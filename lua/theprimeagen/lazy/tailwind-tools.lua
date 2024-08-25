return {
  "luckasRanarison/tailwind-tools.nvim",
  name = "tailwind-tools",
  build = ":UpdateRemotePlugins",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-telescope/telescope.nvim", -- optional
    "neovim/nvim-lspconfig", -- optional
  },
  config = function()
    local lspconfig = require("lspconfig")
    lspconfig.tailwindcss.setup{}
  end,
  opts = {} -- your configuration
}
