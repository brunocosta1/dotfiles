syntax on

set noerrorbells
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set nu
set nowrap
set nobackup
set undodir=~/.vim/undodir
set undofile
set incsearch

call plug#begin('~/.vim/plugged')

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'jremmen/vim-ripgrep'
Plug 'tpope/vim-fugitive'
Plug 'https://github.com/leafgarland/typescript-vim'
Plug 'vim-utils/vim-man'
Plug 'lyuts/vim-rtags'
Plug 'https://github.com/ctrlpvim/ctrlp.vim.git'
Plug 'Valloric/YouCompleteMe', { 'commit':'d98f896' }
Plug 'mbbill/undotree'
Plug 'morhetz/gruvbox'
Plug 'lifepillar/vim-solarized8'
Plug 'powerline/powerline'

call plug#end()

syntax enable
set background=dark
colorscheme solarized8_high
