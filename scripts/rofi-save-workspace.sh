#!/bin/bash

I3_RESURRECT_DIR="$HOME/git/dotfiles/i3-resurrect"

# Input profile name
profile_name=$(rofi -input /dev/null -dmenu -theme base16-default-dark -p "New workspace profile name")
if [ "x$profile_name" == "x" ]; then
    exit 0
fi

# Save workspace profile
if ! find "$I3_RESURRECT_DIR"/profiles/"$profile_name"*; then
    i3-resurrect save -d "$I3_RESURRECT_DIR" -p "$profile_name" --layout-only
    i3-resurrect save -d "$I3_RESURRECT_DIR" -p "$profile_name" --programs-only
    rofi -theme base16-default-dark \
        -e "<span foreground='#A1B56C'><b>Success:</b></span> Saved workspace profile '$profile_name'" \
        -markup
else
    rofi -theme base16-default-dark \
        -e "<span foreground='#AB4642'><b>Error:</b></span> Cannot save workspace profile; '$profile_name' already exists." \
        -markup \
        -theme-str '#window { text-color: @yellow; font: "hack mono bold 11";}'
    exit 1
fi
