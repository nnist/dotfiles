#!/bin/bash
cd "$HOME/.vimwiki" || exit
vim --cmd "silent !source $HOME/.config/base16-shell/scripts/base16-tomorrow.sh" \
    --cmd "set background=light" \
    -c "execute 'color base16-tomorrow'" \
    -c "Goyo" \
    --cmd "let g:gitgutter_enabled=0" \
    index.md
