syntax on

filetype plugin on

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
set nohlsearch
set cursorline
set encoding=utf-8

" My plugins 

call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-fugitive'
Plug 'mbbill/undotree'
Plug 'morhetz/gruvbox'
Plug 'powerline/powerline'
Plug 'Valloric/YouCompleteMe', { 'commit':'d98f896' }
Plug 'vim-airline/vim-airline'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'scrooloose/nerdtree'
Plug 'airblade/vim-gitgutter'
Plug 'tmhedberg/SimpylFold'
Plug 'vim-syntastic/syntastic'
Plug 'nvie/vim-flake8'
Plug 'jnurmine/Zenburn'
Plug 'scrooloose/nerdcommenter'

call plug#end()


" Configuration of colors and others

colorscheme gruvbox
au ColorScheme * hi Normal ctermbg=none guibg=none
au ColorScheme myspecialcolors hi Normal ctermbg=red guibg=red

"set termguicolors
let g:gruvbox_italic=1
let g:gruvbox_underline=1
let g:gruvbox_undercurl=1
let g:gruvbox_bold=1
syntax enable
set background=dark

" Configurations about indentation

set ts=4 sw=4 et
let g:indent_guides_start_level=2
let g:indent_guides_guide_size=1
let g:indent_guides_enable_on_vim_startup=1

" Configurations about airline

let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled = 1


" Configurations for python

set splitbelow
set splitright

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

set foldmethod=indent
set foldlevel=99

nnoremap <space> za
let g:SimpylFold_docstring_preview=1

au BufNewFile,BufRead *.py
    \ set tabstop=4 |
    \ set softtabstop =4 |
    \ set shiftwidth=4 |
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set nowrap
    \ set fileformat=unix

au BufNewFile,BufRead *.js,*.html,*.css
    \ set tabstop=2
    \ set softtabstop=2
    \ set shiftwidth=2


set encoding=utf-8

let g:ycm_autoclose_preview_window_after_completion=1
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>

let python_highlight_all=1
syntax on


" Some binds most used by me
let mapleader=","

map <leader>v :vsplit 
map <leader>h :split
map <leader>Z :wq<CR>

map <F2> :NERDTreeToggle<CR>
map <F3> :UndotreeToggle<CR>
map <C-P> :FZF<CR>
