#!/bin/bash
# shellcheck disable=SC1090
source "$HOME/.config/base16-shell/scripts/base16-default-dark.sh"
cd "$HOME/beancount" || exit
vim personal.beancount
bash
