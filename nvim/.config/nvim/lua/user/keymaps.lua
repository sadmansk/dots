local opts = { noremap = true, silent = true }
local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize +2<CR>", opts)
keymap("n", "<C-Down>", ":resize -2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

keymap("n", "<leader>vo", ":e $MYVIMRC<CR>", opts)  -- open config
keymap("n", "<leader>vr", ":so $MYVIMRC<CR>", opts) -- reload config

-- Visual --
-- Stay in indent mode
--keymap("v", "<", "<gv", opts)
--keymap("v", ">", ">gv", opts)
--
---- Move text up and down
--keymap("v", "<A-j>", ":m .+1<CR>==", opts)
--keymap("v", "<A-k>", ":m .-2<CR>==", opts)
--keymap("v", "p", '"_dP', opts)
--
---- Visual Block --
---- Move text up and down
--keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
--keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
--keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
--keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- Terminal --
-- Better terminal navigation
keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)

-- Plugins
-- vim-fugitive
keymap("n", "<leader>gg", ":G<cr>", opts)
-- vim-maximizer
keymap("n", "<leader>m", ":MaximizerToggle!<CR>", opts)
-- nvim-tree
keymap("n", "<C-n>", ":NvimTreeToggle<CR>", opts)
keymap("n", "<C-m>", ":NvimTreeRefresh<CR>", opts)
-- tree find
keymap("n", "<C-f>", ":NvimTreeFindFile<CR>", opts)

keymap("n", "<tab>", ":tabnext<CR>", opts)
keymap("n", "<s-tab>", ":tabprevious<CR>", opts)

-- telescope
-- find files within current working directory, respects .gitignore
keymap("n", "<leader>ff", "<cmd>Telescope find_files no_ignore=true<cr>", opts) -- find files within current working directory, respects .gitignore
keymap("n", "<leader>fg", "<cmd>Telescope find_files<cr>", opts)				-- find files within current working directory, respects .gitignore

keymap("n", "<leader>fr", "<cmd>Telescope lsp_references<cr>", opts)			-- lists lsp references for word under cursor
keymap("n", "<leader>fd", "<cmd>Telescope lsp_definitions<cr>", opts)			-- find lsp defiitions for word under cursor
keymap("n", "<leader>fi", "<cmd>Telescope lsp_implementations<cr>", opts)			-- find lsp implementations for word under cursor
keymap("n", "<leader>fl", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", opts)		-- lists all lsp symbols in current workspace

keymap("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", opts)					-- find string in current working directory as you type
keymap("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", opts)				-- find string under cursor in current working directory

keymap("n", "<leader>fb", "<cmd>Telescope buffers<cr>", opts)					-- list open buffers in current neovim instance
keymap("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", opts)					-- list available help tags
keymap("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", opts)					-- list available keymaps

keymap("n", "<leader>fp", "<cmd>Telescope resume<cr>", opts)					-- resume last search


-- not keymaps, but custom functions
-- TODO: move to a different files
vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()]]
