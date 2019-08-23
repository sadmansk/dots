" colorscheme stuff
set t_Co=256
colorscheme jellybeans
set shell=zsh
let mapleader = " "

" show existing tab with 4 spaces width
set tabstop=4

" setup vundle
set nocompatible            " be iMproved, required
filetype off                " required

set rtp+=/usr/local/opt/fzf
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'Valloric/YouCompleteMe'
Plugin 'easymotion/vim-easymotion'
Plugin 'rust-lang/rust.vim'
Plugin 'racer-rust/vim-racer'
Plugin 'scrooloose/nerdtree'
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'ramele/agrep'
Plugin 'junegunn/fzf.vim'
Plugin 'ludovicchabant/vim-gutentags'

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
nnoremap <tab>      :tabnext<CR>
nnoremap <s-tab>    :tabprevious<CR>

" Agrep stuff
" Open files in a split window
let g:agrep_results_win_sp_mod = 'vs'
nnoremap K          :Agrep -r "<C-R><C-W>"<CR>:cw<CR>


" Rust stuff "
set hidden
let g:racer_cmd = "/path/to/racer/bin"
let g:racer_experimental_completer = 1
au FileType rust nmap gd <Plug>(rust-def)
au FileType rust nmap gs <Plug>(rust-def-split)
au FileType rust nmap gx <Plug>(rust-def-vertical)
au FileType rust nmap <leader>gd <Plug>(rust-doc)

" NERD tree settings "
" Show nerdtree if no files are specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" Ctrl+n to toggle
map <C-n> :NERDTreeToggle<CR>

" fzf stuff
set rtp+=/usr/local/opt/fzf
" Find in git tracked files
nmap <Leader>f :GFiles<CR>
" Find in all files
nmap <Leader>F :Files<CR>
" Find in open buffer
nmap <Leader>b :Buffers<CR>
" Find in buffer history
nmap <Leader>B :History<CR>
" Find in current tag buffer
nmap <Leader>t :BTags<CR>
" Find in all project tags
nmap <Leader>T :Tags<CR>
" Find in lines in current buffer
nmap <Leader>l :BLines<CR>
" Find in all lines in loaded buffers
nmap <Leader>L :Lines<CR>
" Find in mappings
nmap <Leader>M :Maps<CR>

" Incase GVim is being used "
if has("gui_running")
    set guioptions -=T
    set guioptions -=m
    set guioptions -=r
    set guioptions -=L
    " disable mouse
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

set encoding=utf-8 nobomb
