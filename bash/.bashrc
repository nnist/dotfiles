# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Load bashrc modules
for file in ~/.bashrc.d/*.bashrc; do
    source "$file"
done
