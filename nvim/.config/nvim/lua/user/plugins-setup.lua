-- auto install packer if not installed
local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
        vim.cmd([[packadd packer.nvim]])
        return true
    end
    return false
end
local packer_bootstrap = ensure_packer() -- true if packer was just installed

-- autocommand that reloads neovim and installs/updates/removes plugins
-- when file is saved
vim.cmd([[ 
augroup packer_user_config
autocmd!
autocmd BufWritePost plugins-setup.lua source <afile> | PackerSync
augroup end
]])

-- import packer safely
local status, packer = pcall(require, "packer")
if not status then
    return
end

-- add list of plugins to install
return packer.startup(function(use)
    -- packer can manage itself
    use("wbthomason/packer.nvim")

    use("nvim-lua/plenary.nvim") -- lua functions that many plugins use

    -- statusline
    use("nvim-lualine/lualine.nvim")

    -- git stuff
    use("tpope/vim-fugitive")
    -- file icons
    use("kyazdani42/nvim-web-devicons")
    use("kyazdani42/nvim-tree.lua")
    -- colorscheme
    use("dracula/vim")

    use("christoomey/vim-tmux-navigator")
    use({"akinsho/toggleterm.nvim", tag='*'})

    use("szw/vim-maximizer")


    -- fuzzy finding w/ telescope
    use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" }) -- dependency for better sorting performance
    use({ "nvim-telescope/telescope.nvim", branch = "0.1.x" }) -- fuzzy finder

--    -- autocompletion
--    use("hrsh7th/nvim-cmp") -- completion plugin
--    use("hrsh7th/cmp-buffer") -- source for text in buffer
--    use("hrsh7th/cmp-path") -- source for file system paths
--
--    -- snippets
--    use("L3MON4D3/LuaSnip") -- snippet engine
--    use("saadparwaiz1/cmp_luasnip") -- for autocompletion
--    use("rafamadriz/friendly-snippets") -- useful snippets
--
--    -- managing & installing lsp servers, linters & formatters
--    use("williamboman/mason.nvim") -- in charge of managing lsp servers, linters & formatters
--    use("williamboman/mason-lspconfig.nvim") -- bridges gap b/w mason & lspconfig
--
--    -- configuring lsp servers
--    use("neovim/nvim-lspconfig") -- easily configure language servers
--    use("hrsh7th/cmp-nvim-lsp") -- for autocompletion
--    use({ "glepnir/lspsaga.nvim", branch = "main" }) -- enhanced lsp uis
--    use("jose-elias-alvarez/typescript.nvim") -- additional functionality for typescript server (e.g. rename file & update imports)
--    use("onsails/lspkind.nvim") -- vs-code like icons for autocompletion

    -- programming specific
    use('google/vim-maktaba')
    use('bazelbuild/vim-bazel')

	use {
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v1.x',
		requires = {
			-- LSP Support
			{'neovim/nvim-lspconfig'},             -- Required
			{'williamboman/mason.nvim'},           -- Optional
			{'williamboman/mason-lspconfig.nvim'}, -- Optional

			-- Autocompletion
			{'hrsh7th/nvim-cmp'},         -- Required
			{'hrsh7th/cmp-nvim-lsp'},     -- Required
			{'hrsh7th/cmp-buffer'},       -- Optional
			{'hrsh7th/cmp-path'},         -- Optional
			{'saadparwaiz1/cmp_luasnip'}, -- Optional
			{'hrsh7th/cmp-nvim-lua'},     -- Optional

			-- Snippets
			{'L3MON4D3/LuaSnip'},             -- Required
			{'rafamadriz/friendly-snippets'}, -- Optional
		}
	}


    -- treesitter configuration
    use({ "nvim-treesitter/nvim-treesitter", run = ':TSUpdate'})


    if packer_bootstrap then
        require("packer").sync()
    end
end)

