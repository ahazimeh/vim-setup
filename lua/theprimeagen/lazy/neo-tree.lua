return {
  "kyazdani42/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "kyazdani42/nvim-web-devicons",
  },
  config = function()
    require("nvim-tree").setup {}
      vim.api.nvim_set_keymap(
        'n',         -- normal mode
        '<C-t>',     -- keybinding
        ':NvimTreeToggle<CR>', -- command to toggle nvim-tree
        { noremap = true, silent = true } -- options
      )
  end,
}
