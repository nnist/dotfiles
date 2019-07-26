" vim:fdm=marker
" Plugins {{{
call plug#begin('~/.vim/plugged')

Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'tpope/vim-fugitive'				" Git wrapper
Plug 'sjl/gundo.vim'					" Git-like undo tree
Plug 'airblade/vim-gitgutter'			" Git diff
Plug 'scrooloose/nerdtree'				" File explorer tree
Plug 'Xuyuanp/nerdtree-git-plugin'		" ^ Git plugin
Plug 'weynhamz/vim-plugin-minibufexpl'	" Buffer explorer
function FixupBase16(info)
    !sed -i '/Base16hi/\! s/a:\(attr\|guisp\)/l:\1/g' ~/.vim/plugged/base16-vim/colors/*.vim
endfunction
Plug 'chriskempson/base16-vim', { 'do': function('FixupBase16') }			" Base16 theme
Plug 'davidhalter/jedi-vim'				" Python autocompletion
Plug 'nathangrigg/vim-beancount'        " Vim Beancount
Plug 'w0rp/ale'                         " Asynchronous linting/fixing
Plug 'itchyny/lightline.vim'            " Status line
Plug 'nnist/base16-vim-lightline'       " Base16 theme for lightline
Plug 'maximbaz/lightline-ale'           " ALE indicator for lightline
Plug 'Yggdroot/indentLine'              " Show code indentation
Plug 'bird-get/lslvimazing'             " LSL syntax
"Plug 'vim-syntastic/syntastic'          " Syntastic

call plug#end()
" }}}

" Plugin settings {{{
" ALE {{{
let g:ale_fix_on_save = 1
"let g:ale_lint_on_text_changed = 'never'
"let g:ale_lint_on_enter = 0
" }}}
" indentLine {{{
let g:indentLine_color_term = 18
let g:indentLine_char_list = ['•']
let g:indentLine_fileTypeExclude = ['markdown', 'json']
" }}}
" lightline {{{
set laststatus=2    " Show status line
"set noshowmode      " Hide current mode; already shown in status line
set showmode

let g:lightline = {
      \ 'colorscheme': 'base16_default_dark',
      \ 'active': {
      \   'left': [ ['mode', 'paste'],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ],
      \   'right': [ [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok' ],
      \              [ 'lineinfo'],
      \              [ 'fileformat', 'fileencoding', 'filetype' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head'
      \ },
      \ }

let g:lightline.component_expand = {
      \  'linter_checking': 'lightline#ale#checking',
      \  'linter_warnings': 'lightline#ale#warnings',
      \  'linter_errors': 'lightline#ale#errors',
      \  'linter_ok': 'lightline#ale#ok',
      \ }

let g:lightline.component_type = {
      \     'linter_checking': 'left',
      \     'linter_warnings': 'warning',
      \     'linter_errors': 'error',
      \     'linter_ok': 'left',
      \ }
" }}}
" }}}

" Basic config {{{
set conceallevel=2                     " Conceal bold, italics, underline etc syntax
set tabstop=4                          " Set default indentation to 4 spaces
set shiftwidth=4                       " '                                 '
set updatetime=250                     " 4000 default, 250 for gitgutter
set colorcolumn=80                     " Set line length marker
set nobackup                           " Disable swap and backup for safety
set noswapfile                         " '                                '
set nowritebackup                      " '                                '
"set cursorline
set wrap                               " Word wrapping, only insert line breaks on enter
set linebreak
set nolist                             " List disables linebreak
"set ruler
set number		                         " Show line numbers on left side
"set nowrap		                         " Don't wrap lines
set showcmd		                         " Show partial commands at last line
set autoindent	                       " Keep indentation of prev line
set lazyredraw	                       " Only redraw when needed
set showmatch	                         " Highlight matching [{()}]
set mouse=n                            " Enable mouse scrolling and selection
set visualbell                         " Use visual bell instead of beeping when doing something wrong
set foldenable                         " Enable folding
set foldlevelstart=10                  " Enable most folds by default
set foldnestmax=10                     " Limit fold levels
set expandtab 	                       " Replace tabs with spaces
set foldmethod=indent
let g:markdown_folding=1               " Enable markdown folding
set notimeout ttimeout ttimeoutlen=200 " Quickly time out on keycodes, but never time out on mappings
set incsearch	                         " Search as characters are entered
set hlsearch	                         " Highlight matches
set ignorecase smartcase               " Use case insensitive search, except when using capital letters
set backspace=indent,eol,start         " Allow backspacing over autoindent, line breaks and start of insert action
"set scrolljump=5
set scrolloff=5                        " Set scroll offset
set ttyfast                            " Faster redrawing
" }}}

" Other {{{
" Disable markdown folding
let g:vim_markdown_folding_disabled = 1

" Base16-shell profile helper
if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif

let base16colorspace=256		" Access colors present in 256 colorspace
colorscheme base16-default-dark

" Disable Jedi docstring popup during completion
autocmd FileType python setlocal completeopt-=preview

" Set indentation to 2 spaces for specified filetypes
autocmd BufRead,BufNewFile 
      \ *.beancount,*.html,*.css,*.scss,*.js,.vimrc
      \ setlocal tabstop=2 shiftwidth=2

" Allow cursor change in tmux mode
if exists('$TMUX')
	let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
	let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
	let &t_SI = "\<Esc>]50;CursorShape=1\x7"
	let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif
" }}}

" Bindings {{{
" Close buffer without killing window
nnoremap <leader>q :bp<cr>:bd #<cr>

" Map F5 and F6 to toggle spellcheck
map <F5> :setlocal spell! spelllang=en_us<cr>
map <F6> :setlocal spell! spelllang=nl<cr>

" Bind leader key to ,
let mapleader = ','

" Bind Ctrl-n to toggle NERD tree
map <C-n> :NERDTreeToggle<CR>

" Bind GitGutter stuff
nmap <Leader>ga <Plug>GitGutterStageHunk
nmap <Leader>gu <Plug>GitGutterRevertHunk
nmap <Leader>gd <Plug>GitGutterPreviewHunk
nmap <Leader>gn <Plug>GitGutterNextHunk
nmap <Leader>gp <Plug>GitGutterPrevHunk

" vim-fugitive stuff
"map <Leader>gs :Gstatus<CR>
"map <Leader>gD :Gvdiff<CR>
"map <Leader>gr :Gread<CR>
"map <Leader>gw :Gwrite<CR>
"map <Leader>gB :Gbrowse <C-R>='<C-R><C-G>' =~ ':' ? '<C-R><C-G>' : '-'<CR><CR>
map <Leader>gc :Gcommit<CR>
"map <Leader>ge :Gedit<CR>
"nmap <Leader>gl :Gpull<cr>
"nmap <Leader>gp :Gpush $USER HEAD:
" }}}

" Fuctions {{{
" Enable * and # in visual selection mode
function! s:VSetSearch()
  let temp = @@
  norm! gvy
  let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
  let @@ = temp
endfunction

vnoremap * :<C-u>call <SID>VSetSearch()<CR>//<CR>
vnoremap # :<C-u>call <SID>VSetSearch()<CR>??<CR>
" }}}

" Load .vimrc in git repository {{{
let git_path = system("git rev-parse --show-toplevel 2>/dev/null")
let git_vimrc = substitute(git_path, '\n', '', '') . "/.vimrc"
if !empty(glob(git_vimrc))
  sandbox exec ":source " . git_vimrc
endif
