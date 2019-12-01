#!/bin/bash

icon="盛"

# Retrieve the current color temperature
if pgrep -x redshift &> /dev/null; then
    temp=$(redshift -p 2>/dev/null | grep temp | cut -d' ' -f3)
    temp=${temp//K/}
fi

# Return the icon and color temperature
if [[ -z $temp ]]; then
    echo "$icon -"
else
    echo "$icon ${temp}K"
fi
