vim9script

set encoding=utf-8

source $VIMRUNTIME/defaults.vim

g:mapleader = ' '

set termguicolors
colorscheme habamax

set autoread
set belloff=all
set showmatch

set number
set relativenumber
set cursorline

set ignorecase
set smartcase
set hlsearch

set autoindent
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4

autocmd BufWritePre * keeppatterns :%s/\r$//e
autocmd BufWritePre * setlocal fileformat=unix

set breakindent
set listchars=tab:»·,trail:·,nbsp:␣

inoremap jk <Esc>
inoremap kj <Esc>

nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap <silent> <leader>h :nohlsearch<CR>
nnoremap <silent> <leader>l :set list!<CR>
