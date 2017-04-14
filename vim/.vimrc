" colorscheme stuff
set t_Co=256
colorscheme jellybeans

" show existing tab with 4 spaces width
set tabstop=4

" setup vundle
set nocompatible            " be iMproved, required
filetype off                " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
" powerline
Bundle 'powerline/powerline', {'rtp': 'powerline/bindings/vim/'}
Plugin 'Valloric/YouCompleteMe'
Plugin 'easymotion/vim-easymotion'
Plugin 'racer-rust/vim-racer'

" All of your Plugins must be added before the following line
call vundle#end()           " required
filetype plugin indent on   " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab
set number
set laststatus=2

set cursorline
" set path, useful for finding files
set path=.,,**

syntax on

" show a line at column 80
set colorcolumn=80

" Shortcuts "
" Tabs
nnoremap <tab> :tabnext<CR>
nnoremap <s-tab>   :tabprevious<CR>

" Rust stuff "
au FileType rust nmap gd <Plug>(rust-def)
au FileType rust nmap gs <Plug>(rust-def-split)
au FileType rust nmap gx <Plug>(rust-def-vertical)
au FileType rust nmap <leader>gd <Plug>(rust-doc)

if has("gui_running")
    set guioptions -=T
    set guioptions -=m
    set guioptions -=r
    set guioptions -=L
    set mouse =
endif

" Custom functions
" Remove extra whitespace before saving - from naren's dotfile
function! <SID>StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction
autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()
