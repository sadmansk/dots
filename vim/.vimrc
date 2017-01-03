" colorscheme stuff
set t_Co=256
colorscheme jellybeans

" show existing tab with 4 spaces width
set tabstop=4
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab
filetype plugin indent on
set number

syntax on

" show a line at column 80
set colorcolumn=80

" Shortcuts "
" Tabs
nnoremap <C-Left>   :tabprevious<CR>
nnoremap <C-Right>  :tabnext<CR>

if has("gui_running")
    set guioptions -=T
    set guioptions -=m
endif
