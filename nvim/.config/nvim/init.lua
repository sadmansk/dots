require("user.plugins-setup")
require("user.options")
require("user.keymaps")
require("user.colorscheme")
require("user.lualine")
require("user.telescope")
require("user.nvim-tree")
require("user.nvim-treesitter")
-- require("user.nvim-cmp")
require("user.toggleterm")
require("user.fugitive")
require("user.lsp")

-- require("user.lsp.lspsaga")
-- require("user.lsp.mason")
-- require("user.lsp.lspconfig")
-- require("user.lsp.lsp-zero")

--[[

 " Add maktaba and bazel to the runtimepath.
 " (The latter must be installed before it can be used.)
 Plug 'google/vim-maktaba'
 Plug 'bazelbuild/vim-bazel'
call plug#end()

" color schemes
if (has("termguicolors"))
 set termguicolors
endif
syntax enable
]]
