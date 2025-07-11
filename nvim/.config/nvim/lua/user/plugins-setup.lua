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
    use("ThePrimeagen/git-worktree.nvim")
    -- file icons
    use("kyazdani42/nvim-web-devicons")
    use("kyazdani42/nvim-tree.lua")
    -- colorscheme
    use("dracula/vim")
    use { "catppuccin/nvim", as = "catppuccin" }

    use("christoomey/vim-tmux-navigator")
    use({"akinsho/toggleterm.nvim", tag='*'})

    use("szw/vim-maximizer")


    -- fuzzy finding w/ telescope
    use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" }) -- dependency for better sorting performance
    use({ "nvim-telescope/telescope.nvim", branch = "master" }) -- fuzzy finder

    -- LSP configuration
    use("neovim/nvim-lspconfig") -- Base LSP configuration
    use("mason-org/mason.nvim") -- LSP installer
    use("mason-org/mason-lspconfig.nvim") -- Bridge between mason and lspconfig

    -- Autocompletion
    use("hrsh7th/nvim-cmp") -- completion plugin
    use("hrsh7th/cmp-buffer") -- source for text in buffer
    use("hrsh7th/cmp-path") -- source for file system paths
    use("hrsh7th/cmp-nvim-lsp") -- LSP source for nvim-cmp
    use("hrsh7th/cmp-nvim-lua") -- Lua source for nvim-cmp
    use("onsails/lspkind.nvim") -- icons for completions

    -- Snippets
    use("L3MON4D3/LuaSnip") -- snippet engine
    use("saadparwaiz1/cmp_luasnip") -- for autocompletion
    use("rafamadriz/friendly-snippets") -- useful snippets

    -- debugging
    use({
        'mfussenegger/nvim-dap',
        requires = {
            'rcarriga/nvim-dap-ui',
            'theHamsta/nvim-dap-virtual-text',
            'nvim-neotest/nvim-nio',
            'leoluz/nvim-dap-go',
			'williamboman/mason.nvim',
        }
    })

    -- programming specific
    use('google/vim-maktaba')
    use('bazelbuild/vim-bazel')

    -- treesitter configuration
    use({ "nvim-treesitter/nvim-treesitter", branch = 'master', run = ':TSUpdate'})
    use("nvim-treesitter/nvim-treesitter-context")

    -- save sessions
    use("tpope/vim-obsession")

    -- misc
    use("godlygeek/tabular")
    if packer_bootstrap then
        require("packer").sync()
    end
end)

