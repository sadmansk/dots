return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
             "hrsh7th/cmp-nvim-lsp",
            {
                "folke/lazydev.nvim",
                ft = "lua", -- only load on lua files
                opts = {
                    library = {
                        -- See the configuration section for more details
                        -- Load luvit types when the `vim.uv` word is found
                        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                    },
                },
            },
            { -- optional blink completion source for require statements and module annotations
                "saghen/blink.cmp",
                opts = {
                    sources = {
                        -- add lazydev to your completion providers
                        default = { "lazydev", "lsp", "path", "snippets", "buffer" },
                        providers = {
                            lazydev = {
                                name = "LazyDev",
                                module = "lazydev.integrations.blink",
                                -- make lazydev completions top priority (see `:h blink.cmp`)
                                score_offset = 100,
                            },
                        },
                    },
                },
            },
            {
                "williamboman/mason.nvim",
                lazy = false, -- Load immediately to ensure PATH is set
                cmd = "Mason",
                keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
                build = ":MasonUpdate",
                opts = {
                    ensure_installed = {
                        -- LSP servers (matching your vim.lsp.enable() config)
                        "lua-language-server",         -- Lua LSP
                        "gopls",                       -- Go LSP

                        -- Formatters (for conform.nvim and general use)
                        "stylua",
                        "goimports",
                        -- Note: gofmt comes with Go installation, not managed by Mason
                        --"prettier",
                        --"black",
                        --"isort",
                        "gofumpt",

                        -- Linters and diagnostics
                        --"golangci-lint",
                        --"eslint_d",
                        --"luacheck", -- Lua linting
                        --"pint",     -- Laravel Pint for PHP (formatting & linting)

                        -- Additional useful tools
                        -- "delve",      -- Go debugger
                        -- "shfmt",      -- Shell formatter
                        -- "shellcheck", -- Shell linter

                        -- Optional but useful additions
                        -- "markdownlint", -- Markdown linting
                        -- "yamllint",     -- YAML linting
                        -- "jsonlint",     -- JSON linting
                    },
                },
                config = function(_, opts)
                    -- PATH is handled by core.mason-path for consistency
                    require("mason").setup(opts)

                    -- Auto-install ensure_installed tools with better error handling
                    local mr = require("mason-registry")
                    local function ensure_installed()
                        for _, tool in ipairs(opts.ensure_installed) do
                            if mr.has_package(tool) then
                                local p = mr.get_package(tool)
                                if not p:is_installed() then
                                    vim.notify("Mason: Installing " .. tool .. "...", vim.log.levels.INFO)
                                    p:install():once("closed", function()
                                        if p:is_installed() then
                                            vim.notify("Mason: Successfully installed " .. tool, vim.log.levels.INFO)
                                        else
                                            vim.notify("Mason: Failed to install " .. tool, vim.log.levels.ERROR)
                                        end
                                    end)
                                end
                            else
                                vim.notify("Mason: Package '" .. tool .. "' not found", vim.log.levels.WARN)
                            end
                        end
                    end

                    if mr.refresh then
                        mr.refresh(ensure_installed)
                    else
                        ensure_installed()
                    end
                end,
            },
            "williamboman/mason-lspconfig.nvim",
        },

        config = function ()
            -- Mason setup for LSP server installation
            local mason_status, mason = pcall(require, "mason")
            if not mason_status then
                return
            end

            local mason_lspconfig_status, mason_lspconfig = pcall(require, "mason-lspconfig")
            if not mason_lspconfig_status then
                return
            end

            local lspconfig_status, lspconfig = pcall(require, "lspconfig")
            if not lspconfig_status then
                return
            end

            -- Mason setup
            mason.setup()

            -- Servers to install and configure
            local servers = {
                "cssls",
                "html",
                "pyright",
                "bashls",
                "jsonls",
                "yamlls",
                "gopls",
                "lua_ls", -- for Lua development (replaces nvim_workspace from lsp-zero)
            }

            -- Ensure servers are installed
            mason_lspconfig.setup({
                ensure_installed = servers
            })
            vim.diagnostic.config({
                virtual_lines = true,
                -- virtual_text = true,
                underline = true,
                update_in_insert = false,
                severity_sort = true,
                float = {
                    border = "rounded",
                    source = true,
                },
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = "󰅚 ",
                        [vim.diagnostic.severity.WARN] = "󰀪 ",
                        [vim.diagnostic.severity.INFO] = "󰋽 ",
                        [vim.diagnostic.severity.HINT] = "󰌶 ",
                    },
                    numhl = {
                        [vim.diagnostic.severity.ERROR] = "ErrorMsg",
                        [vim.diagnostic.severity.WARN] = "WarningMsg",
                    },
                },
            })
            -- Setup LSP servers manually instead of using setup_handlers
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            vim.lsp.enable({
                "gopls",
                "lua_ls"
            })

            -- Configure lua_ls
            lspconfig.lua_ls.setup({
                capabilities = capabilities,
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim" } -- Fix undefined global 'vim'
                        },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true),
                            checkThirdParty = false,
                        },
                        telemetry = {
                            enable = false,
                        },
                    },
                }
            })

            -- Configure gopls
            lspconfig.gopls.setup({
                capabilities = capabilities,
                settings = {
                    gopls = {
                        env = {
                            GOPACKAGESDRIVER = './tools/gopackagesdriver.sh'
                        },
                        directoryFilters = {
                            "-bazel-bin",
                            "-bazel-out",
                            "-bazel-testlogs",
                            "-bazel-mypkg",
                        },
                    },
                }
            })

            -- Setup all other servers with default configuration
            for _, server in ipairs(servers) do
                -- Skip servers we've already configured specifically
                if server ~= "lua_ls" and server ~= "gopls" then
                    lspconfig[server].setup({
                        capabilities = capabilities,
                    })
                end
            end

            -- Disable LSP logging unless we're debugging
            vim.lsp.set_log_level("off")
        end

    },
}

