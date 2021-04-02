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
Plug 'rust-lang/rust.vim'
Plug 'lyuts/vim-rtags'
Plug 'https://github.com/ctrlpvim/ctrlp.vim.git'
Plug 'mbbill/undotree'
Plug 'morhetz/gruvbox'
Plug 'lifepillar/vim-solarized8'
Plug 'powerline/powerline'
Plug 'Valloric/YouCompleteMe', { 'commit':'d98f896' }
Plug 'vim-airline/vim-airline'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'scrooloose/nerdtree'
Plug 'airblade/vim-gitgutter'

call plug#end()

colorscheme gruvbox
let g:gruvbox_termcolors= 256
syntax enable
set background=dark

set ts=4 sw=4 et
let g:indent_guides_start_level=2
let g:indent_guides_guide_size=1
let g:indent_guides_enable_on_vim_startup=1

let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled = 1

map <F5> :NERDTreeToggle<CR>
