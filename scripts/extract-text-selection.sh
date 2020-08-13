#!/bin/bash

# Grab a selection and encode it with base64 to easily pass it on
selection=$(grim -g "$(slurp)" - | base64 -)

# Get the average background color
background_color_hex=$(echo "$selection" |
    base64 --decode - |
    convert -resize 1x1 - txt:- |
    awk 'FNR==2{print substr($3,2)}')

# Convert the hex color to int
background_color_int=$(echo "ibase=16; $background_color_hex" | bc)

# Determine if color is closer to black or closer to white; adjust params accordingly
if (("$background_color_int" < 8388607)); then
    invert="-negate -channel RGB"
else
    invert=""
fi

# Process the selection and pass into tesseract
output=$(echo "$selection" |
    base64 --decode - |
    convert $invert - - |
    convert -colorspace gray -type grayscale -level 60%x85% -sharpen 0x4 - - |
    tesseract - "stdout" 2>/dev/null |
    sed -e 's/\f//') # Strip form-feed character from output

echo "$output" | wl-copy -n

notify-send -u normal "Extracted from selection:" "\n$output" -t 10000
