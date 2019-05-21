#!/bin/bash

# Run taskwarrior in firejail every second. Taskwarrior has no read-only
# option, so firejail is used to prevent it from editing and breaking things.

function finish {
    printf "\e[?25h"
    bash
}
trap finish EXIT

source .config/base16-shell/scripts/base16-default-dark.sh
printf "\e[?25l"
while :; do
    output=$(clear; firejail --overlay-tmpfs task schedule rc.defaultwidth=144 2> /dev/null)
    echo "$output"
    sleep 1
done
