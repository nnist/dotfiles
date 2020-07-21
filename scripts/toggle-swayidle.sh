#!/bin/bash
if pgrep -x swayidle &>/dev/null; then
    killall -q swayidle
    notify-send -u normal "Swayidle disabled." -t 1000
else
    swayidle -w \
        timeout 300 'swaylock -f -c 181818' \
        timeout 600 'swaymsg "output * dpms off"' \
        resume 'swaymsg "output * dpms on"' \
        before-sleep 'swaylock -f -c 181818' &
    notify-send -u normal "Swayidle enabled." -t 1000
fi
