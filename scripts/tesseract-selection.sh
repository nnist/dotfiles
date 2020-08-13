#!/bin/bash

# TODO Increase contrast with convert

selection=$(grim -g "$(slurp)" - | base64 -)

output=$(echo "$selection" |
    base64 --decode - |
    convert -colorspace gray -type grayscale -level 60%x85% -sharpen 0x4 - - |
    tesseract - "stdout" 2>/dev/null |
    sed -e 's/\f//')

echo "$output" | wl-copy -n

notify-send -u normal "Extracted from selection:" "\n$output" -t 10000
