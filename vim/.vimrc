" vim:fdm=marker

" {{{ =====  PLUGINS  =========================================================

call plug#begin('~/.vim/plugged')

Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'tpope/vim-fugitive'
Plug 'sjl/gundo.vim'
Plug 'airblade/vim-gitgutter'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'weynhamz/vim-plugin-minibufexpl'
function FixupBase16(info)
    !sed -i '/Base16hi/\! s/a:\(attr\|guisp\)/l:\1/g' ~/.vim/plugged/base16-vim/colors/*.vim
endfunction
Plug 'chriskempson/base16-vim', { 'do': function('FixupBase16') }
Plug 'nathangrigg/vim-beancount'
Plug 'w0rp/ale'
Plug 'itchyny/lightline.vim'
Plug 'nnist/base16-vim-lightline'
Plug 'maximbaz/lightline-ale'
Plug 'Yggdroot/indentLine'
Plug 'bird-get/lslvimazing'
Plug 'metakirby5/codi.vim'
Plug 'vimwiki/vimwiki', { 'branch': 'dev' }
Plug 'tbabej/taskwiki'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'cespare/vim-toml'
Plug 'leafgarland/typescript-vim'
Plug 'mgedmin/coverage-highlight.vim'
Plug 'jpalardy/vim-slime'
Plug 'justinmk/vim-sneak'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'heavenshell/vim-pydocstring'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'ycm-core/YouCompleteMe'

call plug#end()

" }}} =========================================================================
" {{{ =====  PLUGIN SETTINGS  =================================================
" {{{ ----------  ALE  --------------------------------------------------------

let g:ale_fix_on_save = 1
"let g:ale_lint_on_text_changed = 'never'
"let g:ale_lint_on_enter = 0

" }}} ------------------------------------------------------------------------- 
" {{{ ----------  vimwiki and taskwiki  --------------------------------------- 

filetype plugin on
set nocompatible
syntax on
autocmd FileType vimwiki setlocal concealcursor=c
let g:vimwiki_folding = 'expr'
let g:vimwiki_list = [{
      \ 'path': '~/.vimwiki',
      \ 'nested_syntaxes': {
      \   'javascript': 'javascript',
      \   'bash': 'sh',
      \   'python': 'python',
      \   'json': 'json',
      \  },
      \ 'syntax': 'markdown',
      \ 'ext': '.md',
      \ 'path_html': '~/vimwiki/site_html/',
      \ 'list_margin': 0,
      \ }]
let g:taskwiki_disable_concealcursor = 1
let g:taskwiki_markup_syntax = 'markdown'
let g:vimwiki_hl_cb_checked = 1
let g:taskwiki_sort_orders={"S": "scheduled+"}
let g:vimwiki_global_ext = 0
let g:vimwiki_conceal_pre = 1

" Override taskwiki colors to fit base16-default-dark theme
autocmd ColorScheme * highlight TaskWikiTaskActive term=bold cterm=bold ctermfg=2
autocmd ColorScheme * highlight TaskWikiTaskPriority term=bold cterm=bold ctermfg=3
autocmd ColorScheme * highlight TaskWikiTaskDeleted ctermfg=1 ctermbg=0

" Override vimwiki colors to fit base16-default-dark theme
autocmd ColorScheme * highlight VimwikiLink ctermfg=16 cterm=underline
autocmd ColorScheme * highlight VimwikiHR ctermfg=4
autocmd ColorScheme * highlight VimwikiHeaderChar ctermfg=8
autocmd ColorScheme * highlight VimwikiHeader1 term=bold cterm=bold ctermfg=4
autocmd ColorScheme * highlight VimwikiHeader2 term=bold cterm=bold ctermfg=4
autocmd ColorScheme * highlight VimwikiHeader3 term=bold cterm=bold ctermfg=4
autocmd ColorScheme * highlight VimwikiHeader4 term=bold cterm=bold ctermfg=4
autocmd ColorScheme * highlight VimwikiHeader5 term=bold cterm=bold ctermfg=4
autocmd ColorScheme * highlight VimwikiHeader6 term=bold cterm=bold ctermfg=4
autocmd ColorScheme * highlight VimwikiCellSeparator ctermfg=8
autocmd ColorScheme * highlight VimwikiDelText cterm=strikethrough


" }}} ------------------------------------------------------------------------- 
" {{{ ----------  indentLine  -------------------------------------------------

let g:indentLine_color_term = 18
let g:indentLine_char_list = ['•']
let g:indentLine_concealcursor = ""

" }}} ------------------------------------------------------------------------- 
" {{{ ----------  jedi  -------------------------------------------------------

" Disable Jedi docstring popup during completion
autocmd FileType python setlocal completeopt-=preview

" }}} -------------------------------------------------------------------------
" {{{ ----------  lightline  --------------------------------------------------

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

" }}} ------------------------------------------------------------------------- 
" {{{ ---------- vim-markdown  ------------------------------------------------

let g:vim_markdown_folding_disabled = 1

" }}} ------------------------------------------------------------------------- 
" {{{ ----------  fzf  -------------------------------------------------------- 

" Files command with preview window
command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview('up:60%'), <bang>0)

" Ag command with preview window
command! -bang -nargs=* Ag
      \ call fzf#vim#ag(<q-args>,
      \                 fzf#vim#with_preview('up:60%'), <bang>0)

let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

let g:fzf_layout = { 'down': '~90%' }

" }}} ------------------------------------------------------------------------- 
" {{{ ----------  Goyo  ------------------------------------------------------- 

function! s:goyo_enter()
  GitGutterDisable
endfunction

function! s:goyo_leave()
  GitGutterEnable
  GitGutterBufferEnable
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

" }}} ------------------------------------------------------------------------- 
" {{{ ----------  Beancount  -------------------------------------------------- 

autocmd FileType beancount setlocal foldlevel=0

" }}} ------------------------------------------------------------------------- 
" {{{ ----------  vim-slime  -------------------------------------------------- 

let g:slime_target = "tmux"
let g:slime_paste_file = "$HOME/.slime_paste"
let g:slime_python_ipython = 1

" }}} ------------------------------------------------------------------------- 
" {{{ ----------  pydocstring  ------------------------------------------------

let g:pydocstring_doq_path = '~/.local/bin/doq'
let g:pydocstring_formatter = 'sphinx'
let g:pydocstring_templates_path = '~/.vim/pydocstring/templates'

" }}} ------------------------------------------------------------------------- 
" {{{ ----------  UltiSnips  --------------------------------------------------

let g:UltiSnipsExpandTrigger = '<C-Right>'
let g:UltiSnipsJumpForwardTrigger = '<C-Down>'
let g:UltiSnipsJumpBackwardTrigger = '<C-Up>'
let g:UltiSnipsSnippetDirectories=["UltiSnips", $HOME.'/.vim/custom-snippets']

" }}} ------------------------------------------------------------------------- 
" {{{ ----------  YouCompleteMe -----------------------------------------------

augroup YCMCustom
  autocmd!
  autocmd FileType python let b:ycm_hover = {
    \ 'command': 'GetDoc',
    \ 'syntax': 'rst'
    \ }
augroup END

let g:ycm_auto_hover=''

let g:ycm_filetype_specific_completion_to_disable = {
      \ 'gitcommit': 1
      \}
let g:ycm_filetype_blacklist = {
      \ 'tagbar': 1,
      \ 'notes': 1,
      \ 'markdown': 1,
      \ 'netrw': 1,
      \ 'unite': 1,
      \ 'text': 1,
      \ 'vimwiki': 1,
      \ 'pandoc': 1,
      \ 'infolog': 1,
      \ 'leaderf': 1,
      \ 'mail': 1,
      \ 'gitcommit': 1
      \}

" }}} ------------------------------------------------------------------------- 
" }}} =========================================================================
" {{{ =====  BASIC CONFIG  ====================================================

set conceallevel=2                     " Conceal bold, italics, underline etc syntax
set concealcursor=c                    " Do not conceal current line
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
let g:markdown_folding=1               " Enable markdown folding
set notimeout ttimeout ttimeoutlen=200 " Quickly time out on keycodes, but never time out on mappings
set incsearch	                         " Search as characters are entered
set hlsearch	                         " Highlight matches
set ignorecase smartcase               " Use case insensitive search, except when using capital letters
set backspace=indent,eol,start         " Allow backspacing over autoindent, line breaks and start of insert action
"set scrolljump=5
set scrolloff=5                        " Set scroll offset
set ttyfast                            " Faster redrawing
set relativenumber

" }}} =========================================================================
" {{{ =====  OTHER  ===========================================================

" Override base16 theme highlighting
autocmd ColorScheme * highlight Folded ctermfg=19 ctermbg=0

" Base16-shell profile helper
if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif

let base16colorspace=256		" Access colors present in 256 colorspace
colorscheme base16-default-dark

" {{{ ---------- Set filetype indentation  ------------------------------------

autocmd BufRead,BufNewFile 
      \ *.beancount,*.css,*.scss,*.js,.vimrc
      \ setlocal tabstop=2 shiftwidth=2
autocmd BufRead,BufNewFile 
      \ *.html
      \ setlocal tabstop=4 shiftwidth=4

" }}} -------------------------------------------------------------------------
" {{{ ---------- Enable indent and manual folding -----------------------------

augroup vimrc
  au BufReadPre * setlocal foldmethod=indent
  au BufWinEnter * if &fdm == 'indent' | setlocal foldmethod=manual | endif
augroup END

" }}} -------------------------------------------------------------------------
" {{{ ---------- Allow cursor change in tmux mode  ----------------------------

if exists('$TMUX')
	let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
	let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
	let &t_SI = "\<Esc>]50;CursorShape=1\x7"
	let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

" }}} -------------------------------------------------------------------------
" {{{ ----------  Load .vimrc in git repository  ------------------------------

let git_path = system("git rev-parse --show-toplevel 2>/dev/null")
let git_vimrc = substitute(git_path, '\n', '', '') . "/.vimrc"
if !empty(glob(git_vimrc))
  sandbox exec ":source " . git_vimrc
endif

" }}} -------------------------------------------------------------------------
" {{{ ----------  Miscellaneous -----------------------------------------------

" Stop accidentally saving ';' or ':' files due to typo
autocmd BufWritePre [:;]* throw 'Forbidden file name: ' . expand('<afile>')

" }}} -------------------------------------------------------------------------
" }}} =========================================================================
" {{{ =====  BINDINGS  ========================================================

" Bind leader key to ,
let mapleader = ','

" Map F5 and F6 to toggle spellcheck
map <F5> :setlocal spell! spelllang=en_us<cr>
map <F6> :setlocal spell! spelllang=nl<cr>

" Map F10 to show syntax highlight group
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" {{{ ----------  gitgutter  --------------------------------------------------

nmap <Leader>ga <Plug>(GitGutterStageHunk)
nmap <Leader>gu <Plug>(GitGutterRevertHunk)
nmap <Leader>gd <Plug>(GitGutterPreviewHunk)
nmap <Leader>gn <Plug>(GitGutterNextHunk)
nmap <Leader>gp <Plug>(GitGutterPrevHunk)

" }}} -------------------------------------------------------------------------
" {{{ ----------  fzf-vim  --------------------------------------------------

nmap <C-O> :Files<cr>
nmap <C-B> :Buffers<cr>

" }}} -------------------------------------------------------------------------
" {{{ ----------  vim-fugitive  -----------------------------------------------

"map <Leader>gs :Gstatus<CR>
"map <Leader>gD :Gvdiff<CR>
"map <Leader>gr :Gread<CR>
"map <Leader>gw :Gwrite<CR>
"map <Leader>gB :Gbrowse <C-R>='<C-R><C-G>' =~ ':' ? '<C-R><C-G>' : '-'<CR><CR>
map <Leader>gc :Gcommit<CR>
"map <Leader>ge :Gedit<CR>
"nmap <Leader>gl :Gpull<cr>
"nmap <Leader>gp :Gpush $USER HEAD:

" }}} -------------------------------------------------------------------------
" {{{ ----------  coverage-highlight  -----------------------------------------

map <Leader>co :HighlightCoverageOff<CR>
map <Leader>cr :HighlightCoverage<CR>
map <Leader>cn :NextUncovered<CR>
map <Leader>cp :PrevUncovered<CR>

" }}} -------------------------------------------------------------------------
" {{{ ----------  nerdtree  ---------------------------------------------------

" Bind Ctrl-n to toggle NERD tree
map <C-n> :NERDTreeToggle<CR>

" Close buffer without killing window
nnoremap <leader>q :bp<cr>:bd #<cr>

" }}} -------------------------------------------------------------------------
" {{{ ----------  YouCompleteMe  ----------------------------------------------

nmap <Leader>D <plug>(YCMHover)
nmap <Leader>d :YcmCompleter GoToDefinition<CR>
nmap <Leader>r :YcmCompleter RefactorRename 

" }}} -------------------------------------------------------------------------
" }}} =========================================================================
" {{{ =====  FUCTIONS  ========================================================

" Enable * and # in visual selection mode
function! s:VSetSearch()
  let temp = @@
  norm! gvy
  let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
  let @@ = temp
endfunction

vnoremap * :<C-u>call <SID>VSetSearch()<CR>//<CR>
vnoremap # :<C-u>call <SID>VSetSearch()<CR>??<CR>

" }}} =========================================================================

" Disallow unsafe local vimrc commands
set secure
