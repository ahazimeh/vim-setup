return {
    'sbdchd/neoformat',
    config = function()
        -- Use LSP for .cs files, keep original Neoformat for others
        vim.api.nvim_create_user_command("Neoformat", function()
            local filetype = vim.bo.filetype
            if filetype == "cs" then
                vim.lsp.buf.format({ async = false })
            else
                vim.cmd('Neoformat')
            end
        end, { nargs = 0 })
    end
}
