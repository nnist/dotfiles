#!/bin/bash

HIST_FILE="$HOME/git/dotfiles/rofi/.workspace_name_history"
PROFILES_DIR="$HOME/git/dotfiles/i3-resurrect/profiles/"

# Create history file if it doesn't exist
if [ ! -f "$HIST_FILE" ]; then
    touch "$HIST_FILE"
fi

# Select profle
workspaces=$(find "$PROFILES_DIR"*layout.json | sed "s#$PROFILES_DIR##;s#_layout.json##")
ws_profile=$(echo "$workspaces" | rofi -dmenu -theme base16-default-dark -p "(1/3) Select profile")
if [ "x$ws_profile" == "x" ]; then
    exit 0
fi

# Input workspace name
ws_name=$(rofi -input "$HIST_FILE" -dmenu -theme base16-default-dark -p "(2/3) Assign name")
if [ "x$ws_name" == "x" ]; then
    exit 0
fi

# Input workspace number
ws_num=$(rofi -dmenu -theme base16-default-dark -input /dev/null -p "(3/3) Assign number")
if [ "x$ws_num" == "x" ]; then
    exit 0
fi

# Load workspace profile
i3-resurrect restore \
    -d ~/git/dotfiles/i3-resurrect \
    -w "$ws_num · $ws_name" \
    -p "$ws_profile"

# Add workspace name to history
if ! grep "$ws_name" "$HIST_FILE"; then
    echo "$ws_name" >>"$HIST_FILE"
fi
