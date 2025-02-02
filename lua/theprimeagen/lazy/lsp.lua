return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
    },

    config = function()
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")

        vim.api.nvim_create_user_command("RestartVolarLSPFast", function()
            -- Stop all instances of Volar LSP
            for _, client in ipairs(vim.lsp.get_active_clients()) do
                if client.name == "volar" then
                    vim.lsp.stop_client(client.id)
                end
            end

            -- Brief delay before restart
            vim.defer_fn(function()
                -- Only restart Volar if it's not already running
                local clients = vim.lsp.get_active_clients()
                local volar_running = false
                for _, client in ipairs(clients) do
                    if client.name == "volar" then
                        volar_running = true
                        break
                    end
                end

                if not volar_running then
                    vim.cmd("LspStart volar")
                end
            end, 100)
        end, {})

        -- Automatically restart Volar LSP after saving or deleting a .vue file
        vim.api.nvim_create_autocmd({ "BufWritePost", "BufDelete" }, {
            pattern = "*.vue",
            callback = function()
                -- Only restart LSP if the current buffer is valid
                local current_buf = vim.api.nvim_get_current_buf()
                if vim.api.nvim_buf_is_valid(current_buf) then
                    vim.cmd("RestartVolarLSPFast")
                end
            end,
        })


        -- Debugging: Ensure cmp_lsp.default_capabilities() is a valid table
        local default_capabilities = cmp_lsp.default_capabilities()
        if type(default_capabilities) ~= "table" then
            error("cmp_lsp.default_capabilities() did not return a table")
        end

        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            default_capabilities
        )
    capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true


        require("fidget").setup({})
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                'tsserver',
                "lua_ls",
                "rust_analyzer",
                "tailwindcss",
                "gopls",
        "volar",
        "angularls",
        "cssls",
        "csharp_ls",
            },
            handlers = {
                function(server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities
                    }
                end,

                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                runtime = { version = "Lua 5.1" },
                                diagnostics = {
                                    globals = { "vim", "it", "describe", "before_each", "after_each" },
                                }
                            }
                        }
                    }
                end,
        ["csharp_ls"] = function()
    require("lspconfig").csharp_ls.setup({
        capabilities = capabilities,
        root_dir = require("lspconfig").util.root_pattern("*.sln", "*.csproj"),
    })
end,
         ["volar"] = function()
           require("lspconfig").volar.setup({
             capabilities = capabilities,
             -- NOTE: Uncomment to enable volar in file types other than vue.
             -- (Similar to Takeover Mode)

             -- filetypes = { "vue", "javascript", "typescript", "javascriptreact", "typescriptreact", "json" },

             -- NOTE: Uncomment to restrict Volar to only Vue/Nuxt projects. This will enable Volar to work alongside other language servers (tsserver).

             -- root_dir = require("lspconfig").util.root_pattern(
             --   "vue.config.js",
             --   "vue.config.ts",
             --   "nuxt.config.js",
             --   "nuxt.config.ts"
             -- ),
             init_options = {
               vue = {
                 hybridMode = false,
               },
               -- NOTE: This might not be needed. Uncomment if you encounter issues.

               -- typescript = {
               --   tsdk = vim.fn.getcwd() .. "/node_modules/typescript/lib",
               -- },
             },
           })
         end,

["angularls"] = function()
    require("lspconfig").angularls.setup({
        capabilities = capabilities,
        root_dir = require("lspconfig").util.root_pattern("angular.json", ".git"),
    })
end,
        ["cssls"] = function()
    require("lspconfig").cssls.setup({
        capabilities = capabilities,
        settings = {
            css = {
                validate = true, -- Enable CSS validation
            },
            less = {
                validate = true, -- Enable LESS validation
            },
            scss = {
                validate = true, -- Enable SCSS validation
            },
        },
    })
end,
         ["tsserver"] = function()
           local mason_packages = vim.fn.stdpath("data") .. "/mason/packages"
           local volar_path = mason_packages .. "/vue-language-server/node_modules/@vue/language-server"

           require("lspconfig").tsserver.setup({
             capabilities = capabilities,
             -- NOTE: To enable Hybrid Mode, change hybrideMode to true above and uncomment the following filetypes block.
             -- WARN: THIS MAY CAUSE HIGHLIGHTING ISSUES WITHIN THE TEMPLATE SCOPE WHEN TSSERVER ATTACHES TO VUE FILES

             -- filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
             init_options = {
               plugins = {
                 {
                   name = "@vue/typescript-plugin",
                   location = volar_path,
                   languages = { "vue" },
                 },
               },
             },
           })
         end,
                ["gopls"] = function()
                  require("lspconfig").gopls.setup {
                    capabilities = capabilities,
                      settings = {
                          gopls = {
                              analyses = {
                                  unusedparams = true,
                              },
                              staticcheck = true,
                          },
                      },
                  }
                end,
            }
        })

        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' }, -- For luasnip users.
            }, {
                { name = 'buffer' },
            })
        })

        vim.diagnostic.config({
            -- update_in_insert = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
    end
}
