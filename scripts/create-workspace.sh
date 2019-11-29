#!/bin/bash
# Create a workspace with the given profile and workspace number.

# Exit if no arguments are supplied
if [ $# -eq 0 ]; then
    echo "Error: No arguments supplied."
    exit 1
else
    ws_num=$1
    ws_profile=$2
    ws_name=$3
fi

# Use the profile name as the workspace name if it is not specified
if [ -z "$ws_name" ]; then
    ws_name=$ws_profile
fi

# Create the workspace and load the profile. If it already exists, switch to it
if i3-msg -t get_workspaces | grep "$ws_num: $ws_profile"; then
    i3-msg "workspace number $ws_num"
else
    i3-resurrect restore \
    -d ~/git/dotfiles/i3-resurrect \
    -w "$ws_num · $ws_name" \
    -p "$ws_profile"
fi
