" This vimrc is only used for editing dotfiles
let g:ale_linters = {'python': ['mypy', 'flake8']}
let g:ale_fixers = {'python': ['isort', 'black'], 'sh': ['shfmt']}
let g:ale_fix_on_save = 1
set colorcolumn=89                     " Set line length marker
