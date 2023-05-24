# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Load bashrc modules
for file in ~/.bashrc.d/*.bashrc; do
    source "$file"
done

xbindkeys -p
export PATH="/home/nicole:$PATH"

# Disable system beep
xset b off
xset b 0 0 0
