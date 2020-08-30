#!/bin/bash
if ! [[ $DESKTOP_SESSION == "sway" ]]; then
    redshift -x
fi
if pgrep -x redshift &>/dev/null; then
    killall -q redshift
else
    ~/.local/bin/redshift -l 52.09:5.11 -b 1.0:1.0 -t 6500:1900 -r -P &>/dev/null &
fi
