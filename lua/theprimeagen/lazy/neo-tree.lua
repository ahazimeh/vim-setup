return {
  "kyazdani42/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "kyazdani42/nvim-web-devicons",
  },
  config = function()
    require("nvim-tree").setup {
      sync_root_with_cwd = true,
      respect_buf_cwd = true,
      update_focused_file = {
        enable = true,
        update_root = true
      },
    }

    vim.api.nvim_set_keymap(
      'n',         -- normal mode
      '<C-t>',     -- keybinding
      ':NvimTreeToggle<CR>', -- command to toggle nvim-tree
      { noremap = true, silent = true } -- options
    )
  end,
}
