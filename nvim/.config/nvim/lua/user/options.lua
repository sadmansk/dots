vim.opt.completeopt = { "menuone","noinsert","noselect" }
vim.opt.showmatch = true                -- show matching 
vim.opt.ignorecase = true               -- case insensitive 
vim.opt.smartcase = true                -- unless upper case is typed
vim.opt.mouse = "v"                     -- middle-click paste with 
vim.opt.hlsearch = false                 -- highlight search 
vim.opt.incsearch = true                -- incremental search
-- vim.opt.diffopt += "vertical"           -- starts diff mode in vertical split
vim.opt.hidden = true                   -- allow hidden buffers
vim.opt.tabstop=4                       -- number of columns occupied by a tab 
vim.opt.softtabstop=4                   -- see multiple spaces as tabstops so <BS> does the right thing
vim.opt.expandtab = true                -- converts tabs to white space
vim.opt.shiftwidth=4                    -- width for autoindents
vim.opt.smartindent = true               -- indent a new line the same amount as the line just typed
vim.opt.number = true                   -- add line numbers
vim.opt.relativenumber = true           -- add line numbers
vim.opt.wildmode = { "longest", "list" }-- get bash-like tab completions
vim.opt.cc = "80"                       -- set an 80 column border for good coding style
vim.opt.clipboard = "unnamedplus"       -- using system clipboard
vim.opt.cursorline = true               -- highlight current cursorline
vim.opt.ttyfast = true                  -- Speed up scrolling in Vim
vim.opt.shell = "zsh"
vim.opt.splitright = true               -- Open new split panes on right
vim.opt.splitbelow = true               -- Open new split panes below

vim.opt.scrolloff = 8
vim.opt.updatetime = 50


vim.cmd "filetype plugin indent on"     -- allow auto-indenting depending on file type
vim.cmd "syntax on"                     -- syntax highlighting
vim.cmd "filetype plugin on"

vim.cmd "\
if has('python3') \
    set pyx=3 \
endif"

-- autoformat files on save
vim.cmd "autocmd BufWritePost,FileWritePost *.go silent! !gofmt -w %"
vim.cmd "autocmd BufWritePost,FileWritePost *.cue silent! !cue fmt %"
