return {
    'sbdchd/neoformat',
    config = function()
        -- Existing configuration
        vim.g.neoformat_try_prettier = 1
        vim.g.neoformat_enabled_javascript = {'prettier', 'js-beautify'}
        vim.g.neoformat_enabled_typescript = {'prettier', 'tsfmt'}
        vim.g.neoformat_enabled_css = {'prettier', 'cssbeautify'}
        vim.g.neoformat_enabled_html = {'prettier', 'html-beautify'}

        -- Function to check if Prettier is available
        local function prettier_available()
            return vim.fn.executable('prettier') == 1
        end

        -- Modified Neoformat function
        local function neoformat_or_default()
            local view = vim.fn.winsaveview()
            if prettier_available() then
                vim.cmd('Neoformat')
            else
                vim.notify('Prettier not found. Using default formatting.', vim.log.levels.WARN)
                vim.cmd('normal! gg=G')
            end
            vim.fn.winrestview(view)
        end

        -- Run modified Neoformat function on save
        vim.api.nvim_create_autocmd("BufWritePre", {
            pattern = {"*.js", "*.jsx", "*.ts", "*.tsx", "*.css", "*.html"},
            callback = neoformat_or_default,
        })

        -- Override Neoformat command
        vim.api.nvim_create_user_command('Neoformat', neoformat_or_default, {})
    end
}
