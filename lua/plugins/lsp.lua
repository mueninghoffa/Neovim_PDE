return {
    -- 1. Mason: Manages external tools
    {
        "williamboman/mason.nvim",
        config = function() require("mason").setup() end
    },
    -- 2. Mason LSP Config: Bridges Mason and LSP
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "pyright", "ruff" },
                handlers = {
                    -- 1. The Default Handler (for everything else)
                    function(server_name)
                        local capabilities = require("cmp_nvim_lsp").default_capabilities()
                        require("lspconfig")[server_name].setup({
                            capabilities = capabilities
                        })
                    end,

                    -- 2. Specific Handler for Pyright (The Fix)
                    ["pyright"] = function()
                        local capabilities = require("cmp_nvim_lsp").default_capabilities()
                        require("lspconfig").pyright.setup({
                            capabilities = capabilities,
                            settings = {
                                python = {
                                    -- Force Pyright to use the python from the active shell (Conda)
                                    pythonPath = vim.fn.exepath("python"), 
                                    analysis = {
                                        -- Optional: Helps Pyright understand complex imports
                                        autoSearchPaths = true,
                                        useLibraryCodeForTypes = true,
                                    }
                                }
                            }
                        })
                    end,
                }
            })
        end
    },

    -- 3. LSP Config (Logic moved here!)
    {
        "neovim/nvim-lspconfig",
        dependencies = { "hrsh7th/cmp-nvim-lsp" },
        config = function()
            -- 1. Global Diagnostic Config
            vim.diagnostic.config({
                virtual_text = false,
                signs = true,
                underline = true,
                update_in_insert = false,
                severity_sort = true,
                float = {
                    focusable = false,
                    style = "minimal",
                    border = "rounded",
                    source = "always",
                    header = "",
                    prefix = "",
                },
            })

            -- 2. Show diagnostic popup on cursor hover
            -- We use a proper Lua Autocmd here to avoid errors
            vim.api.nvim_create_autocmd("CursorHold", {
                buffer = nil, -- Applies to all buffers
                callback = function()
                    local opts = {
                        focusable = false,
                        close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
                        border = 'rounded',
                        source = 'always',
                        prefix = ' ',
                        scope = 'line',
                    }
                    vim.diagnostic.open_float(nil, opts)
                end
            })
        end
    },

    -- 4. Autocomplete (nvim-cmp)
    {
        "hrsh7th/nvim-cmp",
        dependencies = { "hrsh7th/cmp-nvim-lsp", "L3MON4D3/LuaSnip" },
        config = function()
            local cmp = require("cmp")
            cmp.setup({
                snippet = { expand = function(args) require("luasnip").lsp_expand(args.body) end },
                mapping = cmp.mapping.preset.insert({
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                })
            })
        end
    }
}