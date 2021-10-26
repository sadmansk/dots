set nocompatible            " disable compatibility to old-time vi
set completeopt=menuone,noinsert,noselect
set showmatch               " show matching 
set ignorecase              " case insensitive 
set smartcase               " unless upper case is typed
"set mouse=v                 " middle-click paste with 
set hlsearch                " highlight search 
set incsearch               " incremental search
set diffopt+=vertical " starts diff mode in vertical split
set hidden " allow hidden buffers
set tabstop=4               " number of columns occupied by a tab 
set softtabstop=4           " see multiple spaces as tabstops so <BS> does the right thing
set expandtab               " converts tabs to white space
set shiftwidth=4            " width for autoindents
set autoindent              " indent a new line the same amount as the line just typed
set number                  " add line numbers
set wildmode=longest,list   " get bash-like tab completions
set cc=80                  " set an 80 column border for good coding style
filetype plugin indent on   "allow auto-indenting depending on file type
syntax on                   " syntax highlighting
"set mouse=a                 " enable mouse click
set clipboard=unnamedplus   " using system clipboard
filetype plugin on
set cursorline              " highlight current cursorline
set ttyfast                 " Speed up scrolling in Vim
" set spell                 " enable spell check (may need to download language package)
" set noswapfile            " disable creating swap file
" set backupdir=~/.cache/vim " Directory to store backup files.

let mapleader = " "
set shell=zsh

call plug#begin(stdpath('data').'/plugged')
 " Plugin Section
 Plug 'dracula/vim'
 Plug 'ryanoasis/vim-devicons'
 "Plug 'SirVer/ultisnips'
 "Plug 'honza/vim-snippets'
 Plug 'scrooloose/nerdtree'
 Plug 'preservim/nerdcommenter'
 "Plug 'mhinz/vim-startify'
 Plug 'neoclide/coc.nvim', {'branch': 'release'}
 Plug 'itchyny/lightline.vim'
 Plug 'itchyny/vim-gitbranch'
 Plug 'szw/vim-maximizer'
 Plug 'christoomey/vim-tmux-navigator'
 Plug 'kassio/neoterm'
 Plug 'tpope/vim-commentary'
 Plug 'junegunn/fzf'
 Plug 'junegunn/fzf.vim'
 Plug 'tpope/vim-fugitive'
 Plug 'airblade/vim-gitgutter'
 Plug 'neovim/nvim-lspconfig'
 Plug 'nvim-lua/completion-nvim'
 Plug 'mfussenegger/nvim-jdtls'
 Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
 Plug 'kyazdani42/nvim-web-devicons' " for file icons
 Plug 'kyazdani42/nvim-tree.lua'
call plug#end()

" color schemes
if (has("termguicolors"))
 set termguicolors
endif
syntax enable
" colorscheme evening
colorscheme dracula

" Plugin configs
" lightline and vim-gitbranch
let g:lightline = {
            \ 'active': {
            \   'left': [ [ 'mode', 'paste' ],
            \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
            \ },
            \ 'component_function': {
            \   'gitbranch': 'gitbranch#name'
            \ },
            \ 'colorsheme': 'dracula',
            \ }

" vim-maximizer
nnoremap <leader>m :MaximizerToggle!<CR>

" neoterm
let g:neoterm_default_mod = 'vertical'
let g:neoterm_size = 60
let g:neoterm_autoinsert = 1
nnoremap <c-t> :Ttoggle<CR>
inoremap <c-t> <Esc>:Ttoggle<CR>
tnoremap <c-t> <c-\><c-n>:Ttoggle<CR>

" fzf stuff
" Find in git tracked files
nnoremap <Leader>f :GFiles<CR>
" Find in all files
nnoremap <Leader>F :Files<CR>
" Find in open buffer
nnoremap <Leader>b :Buffers<CR>
" Find in buffer history
nnoremap <Leader>B :History<CR>
" Find in current tag buffer
nnoremap <Leader>t :BTags<CR>
" Find in all project tags
nnoremap <Leader>T :Tags<CR>
" Find in lines in current buffer
nnoremap <Leader>l :BLines<CR>
" Find in all lines in loaded buffers
nnoremap <Leader>L :Lines<CR>
" Find in mappings
nnoremap <Leader>M :Maps<CR>
" Find with ripgrep
nnoremap <Leader>ff :Rg<CR>
inoremap <expr> <c-x><c-f> fzf#vim#complete#path(
    \ "find . -path '*/\.*' -prune -o -print \| sed '1d;s:^..::'",
    \ fzf#wrap({'dir': expand('%:p:h')}))
if has('nvim')
    au! TermOpen * tnoremap <buffer> <Esc> <c-\><c-n>
    au! FileType fzf tunmap <buffer> <Esc>
endif

" vim-fugitive
nnoremap <leader>gg :G<cr>

" lsp and completion
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gh    <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gH    <cmd>lua vim.lsp.code_action<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> gR    <cmd>lua vim.lsp.buf.rename()<CR>

" treesitter
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  ignore_install = { "javascript" }, -- List of parsers to ignore installing
  highlight = {
    enable = true,              -- false will disable the whole extension
    -- disable = { "c", "rust" },  -- list of language that will be disabled
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
EOF

"nvim-tree
lua <<EOF
require'nvim-tree'.setup {
    disable_netrw       = true,
    hijack_netrw        = true,
    open_on_setup       = false,
    ignore_ft_on_setup  = {},
    update_to_buf_dir   = {
    enable = true,
    auto_open = true,
    },
    auto_close          = false,
    open_on_tab         = false,
    hijack_cursor       = false,
    update_cwd          = false,
    diagnostics         = {
    enable = false,
    icons = {
        hint = "",
        info = "",
        warning = "",
        error = "",
        }
    },
    update_focused_file = {
      enable      = false,
      update_cwd  = false,
      ignore_list = {}
    },
    system_open = {
      cmd  = nil,
      args = {}
    },
    view = {
      width = 30,
      height = 30,
      side = 'left',
      auto_resize = false,
      mappings = {
          custom_only = false,
          list = {}
      }
    }
  }
EOF

nnoremap <C-n> :NvimTreeToggle<CR>
lua require 'nvim-tree'.toggle()
nnoremap <C-r> :NvimTreeRefresh<CR>

" open new split panes to right and below
set splitright
set splitbelow

" key mappings
nnoremap <leader>v :e $MYVIMRC<CR>
