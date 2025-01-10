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
    lspconfig.tailwindcss.setup({
      filetypes = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
      init_options = {
        userLanguages = {
          eelixir = "html-eex",
          eruby = "erb"
        }
      },
      settings = {
        tailwindCSS = {
          classAttributes = { "class", "className", "classList", "ngClass" },
          lint = {
            cssConflict = "warning",
            invalidApply = "error",
            invalidConfigPath = "error",
            invalidScreen = "error",
            invalidTailwindDirective = "error",
            invalidVariant = "error",
            recommendedVariantOrder = "warning"
          },
          validate = true
        }
      }
    })

    require("tailwind-tools").setup({
      -- Your tailwind-tools specific options here
    })
  end,
  opts = {} -- your configuration
}
