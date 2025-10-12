return {
    {
        "neovim/nvim-lspconfig",
        version = "2.x",
        dependencies = {
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
            {
                "williamboman/mason.nvim",
                lazy = false, -- Load immediately to ensure PATH is set
                cmd = "Mason",
                keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
                build = ":MasonUpdate",
                opts = {
                    ensure_installed = {
                        -- LSP servers
                        "pyright",
                        "bash-language-server",
                        "lua-language-server",
                        "gopls",
                        "copilot-language-server",

                        -- Formatters (for conform.nvim and general use)
                        "stylua",
                        "goimports",
                        "gofumpt",
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
            local lspconfig = require("lspconfig")
            local mason_lspconfig = require("mason-lspconfig")

            -- Servers to configure (using lspconfig names)
            local servers = {
                "pyright",
                "bashls",
                "gopls",
                "lua_ls",
                "copilot",
            }

            -- Setup mason-lspconfig to automatically install servers
            mason_lspconfig.setup({
                ensure_installed = servers,
                automatic_installation = true,
            })

            -- Diagnostic configuration
            vim.diagnostic.config({
                virtual_lines = true,
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

            -- Get capabilities from blink.cmp if available
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            local has_blink, blink = pcall(require, "blink.cmp")
            if has_blink then
                capabilities = blink.get_lsp_capabilities(capabilities)
            end

            -- Configure lua_ls with specific settings
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

            -- Configure gopls with Bazel settings (from original config)
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

            -- Configure other servers with default settings
            for _, server in ipairs(servers) do
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

