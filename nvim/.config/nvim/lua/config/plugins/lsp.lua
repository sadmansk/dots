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
                "nvimtools/none-ls.nvim",
                config = function()
                    local null_ls = require("null-ls")

                    local group = vim.api.nvim_create_augroup("lsp_format_on_save", { clear = false })
                    local event = "BufWritePre" -- or "BufWritePost"
                    local async = event == "BufWritePost"

                    null_ls.setup({
                        on_attach = function(client, bufnr)
                            if client.supports_method("textDocument/formatting") then
                                vim.keymap.set("n", "<Leader>fm", function()
                                    vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
                                end, { buffer = bufnr, desc = "[lsp] format" })

                                -- format on save
                                vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })
                                vim.api.nvim_create_autocmd(event, {
                                    buffer = bufnr,
                                    group = group,
                                    callback = function()
                                        vim.lsp.buf.format({ bufnr = bufnr, async = async })
                                    end,
                                    desc = "[lsp] format on save",
                                })
                            end

                            if client.supports_method("textDocument/rangeFormatting") then
                                vim.keymap.set("x", "<Leader>fm", function()
                                    vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
                                end, { buffer = bufnr, desc = "[lsp] format" })
                            end
                        end,
                    })
                end,
            },
            {
                "MunifTanjim/prettier.nvim",
                config = function()
                    local prettier = require("prettier")

                    prettier.setup({
                        bin = 'prettierd',
                        filetypes = {
                            "css",
                            "graphql",
                            "html",
                            "javascript",
                            "javascriptreact",
                            "json",
                            "less",
                            "markdown",
                            "scss",
                            "typescript",
                            "typescriptreact",
                            "yaml",
                        },
                    })
                end
            },
            {
                "williamboman/mason.nvim",
                lazy = false, -- Load immediately to ensure PATH is set
                cmd = "Mason",
                keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
                build = ":MasonUpdate",
                opts = {
                    ensure_installed = {
                        -- Copilot language server
                        "copilot-language-server",

                        -- Formatters
                        "stylua",
                        "goimports",
                        "gofumpt",
                        "prettier",
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

            local mason_lspconfig = require("mason-lspconfig")

            -- Servers to configure (using lspconfig names)
            local servers = {
                "bashls",
                "gopls",
                "lua_ls",
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
            vim.lsp.config("lua_ls", {
                cmd = { "lua-language-server" },
                root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml", ".git" },
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
            vim.lsp.config("gopls", {
                cmd = { "gopls" },
                root_markers = { "go.work", "go.mod", ".git" },
                capabilities = capabilities,
                on_attach = function(client)
                    local root = client.config.root_dir
                    if root then
                        client.config.settings.gopls.env.GOPATH = vim.fn.fnamemodify(root .. "/bazel-bin", ":p")
                        client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
                    end
                end,
                settings = {
                    gopls = {
                        env = {
                            GOPATH = nil,
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

            -- Configure bashls
            vim.lsp.config("bashls", {
                cmd = { "bash-language-server", "start" },
                root_markers = { ".git" },
                capabilities = capabilities,
            })

            -- Configure copilot (using config from lsp/copilot.lua)
            local copilot_config = require("lsp.copilot")
            copilot_config.capabilities = capabilities
            vim.lsp.config("copilot", copilot_config)

            -- Enable LSP servers
            vim.lsp.enable("lua_ls")
            vim.lsp.enable("gopls")
            vim.lsp.enable("bashls")
            vim.lsp.enable("copilot")

            -- configure prettier


            -- Disable LSP logging unless we're debugging
            vim.lsp.set_log_level("off")
        end

    },
}

