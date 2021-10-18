#!/bin/bash

HIST_FILE="$HOME/git/dotfiles/rofi/.workspace_name_history"
LAUNCH_SCRIPT="$HOME/git/dotfiles/scripts/create_workspace.py"
EFFECT="$HOME/git/sway-utils/sway_utils/effects/alert.py"
EFFECT_RUNNER="$HOME/git/sway-utils/sway_utils/effects/overlay_term.sh"

# Create history file if it doesn't exist
if [ ! -f "$HIST_FILE" ]; then
    touch "$HIST_FILE"
fi

# Select profle
workspaces=$(find "$PROFILES_DIR"*layout.json | sed "s#$PROFILES_DIR##;s#_layout.json##")
ws_profile=$($LAUNCH_SCRIPT -l | rofi -dmenu -theme base16-default-dark -p "(1/4) Select profile")
if [ "x$ws_profile" == "x" ]; then
    exit 0
fi

# Input workspace name
ws_name=$(rofi -input "$HIST_FILE" -dmenu -theme base16-default-dark -p "(2/4) Assign name")
if [ "x$ws_name" == "x" ]; then
    exit 0
fi

# Input workspace number
ws_num=$(rofi -dmenu -theme base16-default-dark -input /dev/null -p "(3/4) Assign number")
if [ "x$ws_num" == "x" ]; then
    exit 0
fi

# Input working directory
ws_dir=$(readlink -e ~/git/* | rofi -dmenu -theme base16-default-dark -p "(4/4) Set working directory")
if [ "x$ws_dir" == "x" ]; then
    exit 0
fi

$EFFECT_RUNNER "$EFFECT 'LOADING...' 'yellow'" &
sleep .5

# Load workspace profile
$($LAUNCH_SCRIPT --profile $ws_profile --num $ws_num --name $ws_name -d $ws_dir)

$EFFECT_RUNNER "$EFFECT 'WORKSPACE CREATED' 'white'"

# Add workspace name to history
if ! grep "$ws_name" "$HIST_FILE"; then
    echo "$ws_name" >>"$HIST_FILE"
fi
