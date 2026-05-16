return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = 'main',
        lazy = false,
        build = ":TSUpdate",
        dependencies = {
            { "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
            "nvim-treesitter/nvim-treesitter-context",
        },
        config = function()
            require('nvim-treesitter').setup {}

            -- Enable treesitter highlighting for common filetypes
            local parsers = { "go", "python", "javascript", "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" }

            -- Install parsers on startup
            require('nvim-treesitter').install(parsers)

            -- Enable highlighting via FileType autocommand
            vim.api.nvim_create_autocmd('FileType', {
                pattern = parsers,
                callback = function(ev)
                    local max_filesize = 100 * 1024 -- 100 KB
                    local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(ev.buf))
                    if ok and stats and stats.size > max_filesize then
                        return
                    end
                    vim.treesitter.start()
                end,
            })
        end,
    }
}
