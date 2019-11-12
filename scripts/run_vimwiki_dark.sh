#!/bin/bash
# shellcheck disable=SC1090
source "$HOME/.config/base16-shell/scripts/base16-default-dark.sh"
cd "$HOME/.vimwiki" || exit
vim -c "Goyo" \
    --cmd "let g:gitgutter_enabled=0" \
    index.md
