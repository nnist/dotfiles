#!/bin/bash
source "$HOME/.config/base16-shell/scripts/base16-tomorrow.sh"
cd "$HOME/.vimwiki" || exit
vim -c Goyo index.md
