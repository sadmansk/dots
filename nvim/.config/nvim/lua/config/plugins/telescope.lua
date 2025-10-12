return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    -- or                              , branch = '0.1.x',
    dependencies = {
        {'nvim-lua/plenary.nvim' },
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" }, -- dependency for better sorting performance
    },
    config = function()
        -- import telescope plugin safely
        local telescope_setup, telescope = pcall(require, "telescope")
        if not telescope_setup then
            return
        end
        -- import telescope actions safely
        local actions_setup, actions = pcall(require, "telescope.actions")
        if not actions_setup then
            return
        end

        -- configure telescope
        telescope.setup({
            -- configure custom mappings
            defaults = {
                path_display = { "truncate" },
                mappings = {
                    i = {
                        ["<C-k>"] = actions.move_selection_previous, -- move to prev result
                        ["<C-j>"] = actions.move_selection_next, -- move to next result
                        --["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist, -- send selected to quickfixlist
                    },
                },
            },
            extensions = {
                fzf = {
                    fuzzy = true,                    -- false will only do exact matching
                    override_generic_sorter = true,  -- override the generic sorter
                    override_file_sorter = true,     -- override the file sorter
                    case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                    -- the default case_mode is "smart_case"
                },
            },
            pickers = {
                colorscheme = {
                    enable_preview = true,
                },
            },
        })
        telescope.load_extension("fzf")

        -- Shorten function name
        local keymap = vim.api.nvim_set_keymap
        local keymap_opts = { noremap = true, silent = true }
        -- telescope
        -- find files within current working directory, respects .gitignore
        keymap("n", "<leader>ff", "<cmd>Telescope find_files no_ignore=true<cr>", keymap_opts) -- find files within current working directory, respects .gitignore
        keymap("n", "<leader>fg", "<cmd>Telescope find_files<cr>", keymap_opts)				-- find files within current working directory, respects .gitignore

        keymap("n", "<leader>fr", "<cmd>Telescope lsp_references<cr>", keymap_opts)			-- lists lsp references for word under cursor
        keymap("n", "<leader>fd", "<cmd>Telescope lsp_definitions<cr>", keymap_opts)			-- find lsp defiitions for word under cursor
        keymap("n", "<leader>fi", "<cmd>Telescope lsp_implementations<cr>", keymap_opts)			-- find lsp implementations for word under cursor
        keymap("n", "<leader>fl", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", keymap_opts)		-- lists all lsp symbols in current workspace

        keymap("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", keymap_opts)					-- find string in current working directory as you type
        keymap("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", keymap_opts)				-- find string under cursor in current working directory

        keymap("n", "<leader>fb", "<cmd>Telescope buffers<cr>", keymap_opts)					-- list open buffers in current neovim instance
        keymap("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", keymap_opts)					-- list available help tags
        keymap("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", keymap_opts)					-- list available keymaps

        keymap("n", "<leader>fp", "<cmd>Telescope resume<cr>", keymap_opts)					-- resume last search
        keymap("n", "<leader>ft", "<cmd>Telescope colorscheme<cr>", keymap_opts)					-- resume last search
    end,
}
