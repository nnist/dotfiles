#!/bin/bash
# shellcheck disable=SC1090
source "$HOME/.config/base16-shell/scripts/base16-default-dark.sh"
cd "$HOME/git/taskschedule" || exit
firejail --net=none --private-dev --shell=none python3 __main__.py --from today-7days --to today+7days
