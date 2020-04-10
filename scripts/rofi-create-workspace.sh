#!/bin/bash

# Select profle
PROFILES_DIR="$HOME/git/dotfiles/i3-resurrect/profiles/"
workspaces=$(find "$PROFILES_DIR"*layout.json | sed "s#$PROFILES_DIR##;s#_layout.json##")
ws_profile=$(echo "$workspaces" | rofi -dmenu -theme base16-default-dark -p "(1/3) Select profile")
if [ "x$ws_profile" == "x" ]; then
    exit 0
fi

# Input workspace name
ws_name=$(rofi -dmenu -theme base16-default-dark -input /dev/null -p "(2/3) Assign name")
if [ "x$ws_name" == "x" ]; then
    exit 0
fi

# Input workspace number
ws_num=$(rofi -dmenu -theme base16-default-dark -input /dev/null -p "(3/3) Assign number")
if [ "x$ws_num" == "x" ]; then
    exit 0
fi

i3-resurrect restore \
    -d ~/git/dotfiles/i3-resurrect \
    -w "$ws_num · $ws_name" \
    -p "$ws_profile"
