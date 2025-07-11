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

-- Diagnostics configuration (equivalent to lsp-zero's preferences)
vim.diagnostic.config({
  virtual_text = true,
  signs = {
    active = {
      { name = "DiagnosticSignError", text = "E" },
      { name = "DiagnosticSignWarn", text = "W" },
      { name = "DiagnosticSignHint", text = "H" },
      { name = "DiagnosticSignInfo", text = "I" },
    },
  },
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    border = "rounded",
    source = "always",
  },
})

-- Setup LSP servers manually instead of using setup_handlers
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Global on_attach function for all servers
local on_attach = function(client, bufnr)
  -- Keybindings (same as in the original config)
  local bufopts = { buffer = bufnr, noremap = true, silent = true }
  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, bufopts)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, bufopts)
  vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, bufopts)
  vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, bufopts)
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, bufopts)
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, bufopts)
  vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end, bufopts)
  vim.keymap.set("n", "<leader>rr", function() vim.lsp.buf.references() end, bufopts)
  vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, bufopts)
  vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, bufopts)
end

-- Configure lua_ls
lspconfig.lua_ls.setup({
  on_attach = on_attach,
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
  on_attach = on_attach,
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
      on_attach = on_attach,
      capabilities = capabilities,
    })
  end
end

-- Disable LSP logging unless we're debugging
vim.lsp.set_log_level("off")
