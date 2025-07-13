" Basic Vim configuration
set nocompatible

" Display settings
set number
set relativenumber
set ruler
set showcmd
set showmode
set laststatus=2

" Search settings
set hlsearch
set incsearch
set ignorecase
set smartcase

" Indentation settings
set autoindent
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab

" General settings
set mouse=a
set clipboard=unnamed
set backspace=indent,eol,start
set wildmenu
set wildmode=longest,list,full

" Color scheme
syntax on
colorscheme default

" Key mappings
nnoremap <C-n> :nohl<CR>
nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>a

" File type specific settings
autocmd FileType python setlocal tabstop=4 shiftwidth=4 expandtab
autocmd FileType javascript setlocal tabstop=2 shiftwidth=2 expandtab
autocmd FileType html setlocal tabstop=2 shiftwidth=2 expandtab
autocmd FileType css setlocal tabstop=2 shiftwidth=2 expandtab
