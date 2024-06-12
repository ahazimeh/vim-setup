local function unstage_current_file()

    local file_path = vim.fn.expand('%:p')
    print(file_path)
    vim.cmd('Git reset "' .. file_path .. '"')
end

local function reset_changes_in_current_file()
    -- Get the full path of the current file
    local file_path = vim.fn.expand('%:p')
    -- Surround the file path with double quotes to handle spaces
    vim.cmd('Git checkout -- "' .. file_path .. '"')
end

return {
    "tpope/vim-fugitive",
    config = function()
        vim.keymap.set("n", "<leader>gs", vim.cmd.Git)

        local ThePrimeagen_Fugitive = vim.api.nvim_create_augroup("ThePrimeagen_Fugitive", {})

        local autocmd = vim.api.nvim_create_autocmd
        autocmd("BufWinEnter", {
            group = ThePrimeagen_Fugitive,
            pattern = "*",
            callback = function()
                if vim.bo.ft ~= "fugitive" then
                    return
                end

                local bufnr = vim.api.nvim_get_current_buf()
                local opts = {buffer = bufnr, remap = false}
                vim.keymap.set("n", "<leader>p", function()
                    vim.cmd.Git('push')
                end, opts)

                -- rebase always
                vim.keymap.set("n", "<leader>P", function()
                    vim.cmd.Git({'pull',  '--rebase'})
                end, opts)

                -- NOTE: It allows me to easily set the branch i am pushing and any tracking
                -- needed if i did not set the branch up correctly
                vim.keymap.set("n", "<leader>t", ":Git push -u origin ", opts);
            end,
        })


        vim.keymap.set("n", "gu", "<cmd>diffget //2<CR>")
        vim.keymap.set("n", "gh", "<cmd>diffget //3<CR>")

        -- windows keybindings
        vim.keymap.set('n', '<leader>gr', unstage_current_file, { noremap = true, silent = true })
        vim.keymap.set('n', '<leader>gR', reset_changes_in_current_file, { noremap = true, silent = true })
    end
}
