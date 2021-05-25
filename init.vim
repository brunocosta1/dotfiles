syntax on
filetype plugin on

" ------------------------------- General Settings  ----------------------------

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

" Status Line

"set stl=
"set stl+=%#PmenuSel#
"set stl+=\ %M
"set stl+=\ %y
"set stl+=\ %r
"set stl+=\ %F

"set stl+=\%=
"set stl+=%#DiffChange#
"set stl+=\ %c:%l/%L
"set stl+=\ %p%%
"set stl+=\ [%n]

set stl+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set stl+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" -------------------- My plugins ----------------------------------------

call plug#begin('~/.config/nvim/plugged')

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'tpope/vim-fugitive'
Plug 'vim-utils/vim-man'
Plug 'mbbill/undotree'
Plug 'morhetz/gruvbox'
Plug 'powerline/powerline'
Plug 'Valloric/YouCompleteMe', { 'commit':'d98f896' }
Plug 'nathanaelkane/vim-indent-guides'
Plug 'scrooloose/nerdtree'
Plug 'airblade/vim-gitgutter'
Plug 'tmhedberg/SimpylFold'
Plug 'vim-syntastic/syntastic'
Plug 'scrooloose/nerdcommenter'
Plug 'edkolev/tmuxline.vim'
Plug 'vim-airline/vim-airline'

call plug#end()


" --------------------------Configuration of colors----------------------- 

set termguicolors
"let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
"let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
colorscheme gruvbox
let g:gruvbox_italic=1
let g:gruvbox_underline=1
let g:gruvbox_undercurl=1
let g:gruvbox_bold=1
syntax enable
set background=dark

" --------------------Configurations about indentation---------------------

set ts=4 sw=4 et
let g:indent_guides_start_level=2
let g:indent_guides_guide_size=1
let g:indent_guides_enable_on_vim_startup=1

" Configurations about airline
let g:airline_theme='gruvbox'
let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled = 1

" Configurations for python

set splitbelow
set splitright
set foldmethod=indent
set foldlevel=99

let g:SimpylFold_docstring_preview=1

au BufNewFile,BufRead *.py
    \ set tabstop=4 | 
    \ set softtabstop =4 |
    \ set shiftwidth=4 |
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix



let g:ycm_autoclose_preview_window_after_completion=1
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>
let python_highlight_all=1

" --------------------------------------------------- Key Bindings -------------

let mapleader=","

nnoremap <space> za
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
nnoremap <Up> :resize +2<CR>
nnoremap <Down> :resize -2<CR>
nnoremap <Left> :vertical resize +2<CR>
nnoremap <Right> :vertical resize -2<CR>
xnoremap K :move '<-2<CR>gv-gv
xnoremap J :move '>+1<CR>gv-gv

map <leader>v :vsplit 
map <leader>h :split
map <leader>Z :wq<CR>
map <F2> :NERDTreeToggle<CR>
map <F3> :UndotreeToggle<CR>
map <C-P> :FZF<CR>
map <C-s> :source ~/.config/nvim/init.vim<CR>
noremap <leader>Y "+y

map <TAB> :bn<CR>
map <S-TAB> :bp<CR>
