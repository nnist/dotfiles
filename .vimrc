" vim:fdm=marker

" TODO Auto-fold vimrc

" vim-plug plugins {{{
call plug#begin('~/.vim/plugged')

Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'https://github.com/vimwiki/vimwiki.git'
Plug 'alessandroyorba/despacio'

call plug#end()
" }}}

" Themes
colorscheme despacio

" Conceal bold, italics, underline etc syntax
set conceallevel=2

" Disable folding
let g:vim_markdown_folding_disabled = 1

set nocompatible
filetype indent plugin on " Enable plugins and indenting per filetype
syntax on		" Syntax highlighting

" Set tabs to 4 spaces
set tabstop=4
set shiftwidth=4
"set expandtab 	" Replace tabs with spaces

" Disable swap and backup for safety
set nobackup
set noswapfile
set nowritebackup

"set ruler
set number		" Show line numbers on left side

set showmode 	" Always show current mode
set nowrap		" Don't wrap lines
set showcmd		" Show partial commands at last line
set autoindent	" Keep indentation of prev line
set lazyredraw	" Only redraw when needed
set showmatch	" Highlight matching [{()}]

" Use visual bell instead of beeping when doing something wrong
set visualbell

set foldenable          " Enable folding
set foldlevelstart=10   " Enable most folds by default
set foldnestmax=10      " Limit fold levels
set foldmethod=manual   " Manual folding

" Quickly time out on keycodes, but never time out on mappings
set notimeout ttimeout ttimeoutlen=200

set incsearch	" Search as characters are entered
set hlsearch	" Highlight matches

" Use case insensitive search, except when using capital letters
	set ignorecase
	set smartcase

" Allow backspacing over autoindent, line breaks and start of insert action
set backspace=indent,eol,start

" Allow cursor change in tmux mode
if exists('$TMUX')
	let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
	let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
	let &t_SI = "\<Esc>]50;CursorShape=1\x7"
	let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif
