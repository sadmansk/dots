-- autoformat files on save
vim.cmd "autocmd BufWritePost,FileWritePost *.go silent! !gofumpt -l -w %"
vim.cmd "autocmd BufWritePost,FileWritePost *.cue silent! !cue fmt %"
vim.cmd "autocmd BufWritePost,FileWritePost *.tf silent! !terraform fmt %"

-- remove trailing whitespace
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  callback = function()
        local save_cursor = vim.fn.getpos(".")
        vim.cmd([[%s/\s\+$//e]])
        vim.fn.setpos(".", save_cursor)
    end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
    callback = function(event)
        local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
        end

        -- defaults:
        -- https://neovim.io/doc/user/news-0.11.html#_defaults

        --map("gl", vim.diagnostic.open_float, "Open Diagnostic Float")
        --map("K", vim.lsp.buf.hover, "Hover Documentation")
        --map("gs", vim.lsp.buf.signature_help, "Signature Documentation")
        --map("gD", vim.lsp.buf.declaration, "Goto Declaration")
        --map("<leader>la", vim.lsp.buf.code_action, "Code Action")
        --map("<leader>lr", vim.lsp.buf.rename, "Rename all references")
        --map("<leader>lf", vim.lsp.buf.format, "Format")
        --map("<leader>v", "<cmd>vsplit | lua vim.lsp.buf.definition()<cr>", "Goto Definition in Vertical Split")

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

        local function client_supports_method(client, method, bufnr)
            if vim.fn.has 'nvim-0.11' == 1 then
                return client:supports_method(method, bufnr)
            else
                return client.supports_method(method, { bufnr = bufnr })
            end
        end
    end,

})
