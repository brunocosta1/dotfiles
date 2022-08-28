if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

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
