#!/bin/bash
cd "$HOME/.vimwiki" || exit
vim --cmd "silent !source $HOME/.config/base16-shell/scripts/base16-grayscale-light.sh" \
    --cmd "set background=light" \
    -c "execute 'color base16-grayscale-light'" \
    -c "Goyo" \
    --cmd "let g:gitgutter_enabled=0" \
    index.md
