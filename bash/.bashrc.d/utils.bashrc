#!/bin/bash
# This contains utility functions that are used by other functions.

# confirm - ask for confirmation
confirm() {
    # from https://gist.github.com/davejamesmiller/1965569
    local prompt default reply

    if [ "${2:-}" = "Y" ]; then
        prompt="Y/n"
        default=Y
    elif [ "${2:-}" = "N" ]; then
        prompt="y/N"
        default=N
    else
        prompt="y/n"
        default=
    fi

    while true; do
        # Ask the question (not using "read -p" as it uses stderr not stdout)
        echo -n "$1 [$prompt] "

        # Read the answer (use /dev/tty in case stdin is redirected from somewhere else)
        read reply </dev/tty

        # Default?
        if [ -z "$reply" ]; then
            reply=$default
        fi

        # Check if the reply is valid
        case "$reply" in
        Y* | y*) return 0 ;;
        N* | n*) return 1 ;;
        esac

    done
}

# settitle - set the current window's title
settitle() {
    title="$1"
    PROMPT_COMMAND='echo -ne "\033]2;$title\007"'
}

# settitle_pwd - set the current window's title based on last part of pwd
settitle_pwd() {
    title=$(basename "$(pwd)")
    PROMPT_COMMAND='echo -ne "\033]2;$title\007"'
}
