return {
    {
        "ishan9299/nvim-solarized-lua",
        lazy = false,
        priority = 1000,
        config = function()
        end
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd([[colorscheme catppuccin-macchiato]])
        end
    },
    {
        "thesimonho/kanagawa-paper.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
    },
}
