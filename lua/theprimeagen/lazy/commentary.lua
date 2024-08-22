return {
  {
    "tpope/vim-commentary",
    event = "VeryLazy",
    config = function()
      -- Function to determine if cursor is inside JSX
      local function is_inside_jsx()
        local buf = vim.api.nvim_get_current_buf()
        local row, col = unpack(vim.api.nvim_win_get_cursor(0))
        row = row - 1  -- API is 0-indexed

        local parser = vim.treesitter.get_parser(buf, "tsx")
        if not parser then return false end

        local tree = parser:parse()[1]
        local root = tree:root()

        local node = root:named_descendant_for_range(row, col, row, col)
        while node do
          if node:type() == "jsx_element" or node:type() == "jsx_fragment" then
            return true
          end
          node = node:parent()
        end
        return false
      end

      -- Function to set appropriate comment string
      local function set_comment_string()
        if is_inside_jsx() then
          vim.bo.commentstring = '{/* %s */}'
        else
          vim.bo.commentstring = '// %s'
        end
      end

      -- Set up autocommand to update comment string before commenting
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
        callback = function()
          vim.api.nvim_create_autocmd("CursorMoved", {
            buffer = 0,
            callback = set_comment_string
          })
        end
      })
    end,
    keys = {
      { "<C-_>", "<Plug>CommentaryLine", mode = "n", desc = "Comment line" },
      { "<C-_>", "<Plug>Commentary", mode = "v", desc = "Comment selection" },
    },
  },
}
