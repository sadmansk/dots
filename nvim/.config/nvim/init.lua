require("user.keymaps")
require("config.lazy")
require("config.autocmds")
require("user.options")
-- require("user.plugins-setup")
---- require("user.nvim-cmp")
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
