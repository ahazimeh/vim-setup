return {
    'sbdchd/neoformat',
    config = function()
        -- Attempt to use Prettier, fall back to default formatting if not available
        vim.g.neoformat_try_prettier = 1

        -- Define a list of formatters to try
        vim.g.neoformat_enabled_javascript = {'prettier', 'js-beautify'}
        vim.g.neoformat_enabled_typescript = {'prettier', 'tsfmt'}
        vim.g.neoformat_enabled_css = {'prettier', 'cssbeautify'}
        vim.g.neoformat_enabled_html = {'prettier', 'html-beautify'}

        -- Run Neoformat on save
        vim.api.nvim_create_autocmd("BufWritePre", {
            pattern = {"*.js", "*.jsx", "*.ts", "*.tsx", "*.css", "*.html"},
            callback = function()
                vim.cmd("Neoformat")
            end,
        })

        -- Function to check if Prettier is available
        local function prettier_available()
            return vim.fn.executable('prettier') == 1
        end

        -- Override Neoformat command to handle Prettier absence
        vim.api.nvim_create_user_command('Neoformat', function()
            if prettier_available() then
                vim.cmd('Neoformat')
            else
                vim.notify('Prettier not found. Using default formatting.', vim.log.levels.WARN)
                vim.cmd('normal! gg=G')
            end
        end, {})
    end
}
