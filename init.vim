if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

if !has('gui_running') && &term =~ '^\%(screen\|tmux\)'
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

set termguicolors
syntax on


lua << EOF
require('plugins')
require('apparence')
require('scope')
require('terminal')
require('autocomplete')
require('servers')
require('bindings')
EOF


set nu
set cursorline
set encoding=UTF-8
set undodir=~/.vim/undodir
set expandtab
set nohlsearch
set noerrorbells
set smartindent
set undofile
set incsearch
set nowrap
set background=dark

if &filetype ==# "python"
  set tabstop=4
  set shiftwidth=4
  set softtabstop=4
endif

set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

" au ColorScheme * hi Normal ctermbg=none guibg=none
" au ColorScheme myspecialcolors hi Normal ctermbg=red guibg=red

syntax on
filetype plugin on
let g:python_host_prog  = '/usr/bin/python2' 
let g:python3_host_prog  = '/usr/bin/python3' 
set completeopt=menu,menuone,noselect

autocmd BufNewFile README.md 0r ~/skeletons/README.md
autocmd BufNewFile *.c 0r ~/skeletons/main.c
autocmd BufNewFile *.py 0r ~/skeletons/main.py


" set
autocmd TermEnter term://*toggleterm#*
      \ tnoremap <silent><c-t> <Cmd>exe v:count1 . "ToggleTerm"<CR>

" By applying the mappings this way you can pass a count to your
" mapping to open a specific window.
" For example: 2<C-t> will open terminal 2
nnoremap <silent><c-t> <Cmd>exe v:count1 . "ToggleTerm"<CR>
inoremap <silent><c-t> <Esc><Cmd>exe v:count1 . "ToggleTerm"<CR>
