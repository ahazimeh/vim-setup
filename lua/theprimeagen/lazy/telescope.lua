return {
    "nvim-telescope/telescope.nvim",

    dependencies = {
        "nvim-lua/plenary.nvim"
    },

    config = function()
        local actions = require('telescope.actions')

        -- Define the open_and_resume function
        local M = {}
        M.actions = {}
        M.actions.open_and_resume = function(prompt_bufnr)
            --require('telescope.actions').select_default(prompt_bufnr)
            require('telescope.builtin').resume()
            require('telescope.builtin').resume()
        end

        require('telescope').setup({
                  defaults = {
                mappings = {
                    i = {
                        ["<C-o>"] = M.actions.open_and_resume
                    },
                    n = {
                        ["<C-o>"] = M.actions.open_and_resume
                    }
                }
            }
    })

    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>re', function()
      require('telescope.builtin').resume()
    end)
        vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
        vim.keymap.set('n', '<C-p>', builtin.git_files, {})
        vim.keymap.set('n', '<leader>pws', function()
            local word = vim.fn.expand("<cword>")
            builtin.grep_string({ search = word })
        end)
        vim.keymap.set('n', '<leader>pWs', function()
            local word = vim.fn.expand("<cWORD>")
            builtin.grep_string({ search = word })
        end)
        vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
        vim.keymap.set('n', '<leader>ps', function()
            builtin.grep_string({ search = vim.fn.input("Grep > ") })
        end)
        vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})
    end
}

