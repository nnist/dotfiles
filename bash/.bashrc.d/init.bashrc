#!/bin/bash

HISTCONTROL=ignoreboth # Ignore duplicate lines and lines starting with space
shopt -s histappend # Append history; don't overwrite
HISTSIZE=1000
HISTFILESIZE=2000
HISTIGNORE="clear:exit*:poweroff*:reboot*:git checkout*"

shopt -s checkwinsize # Prevent terminal window from messing up
export EDITOR=vim

# Alias definitions
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Add bash completions
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    fi
    if [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
    if [ -d ~/.bash_completion.d ]; then
        for f in ~/.bash_completion.d/*; do
            . $f
        done
    fi
fi

# Add ~/.local/bin to path
if [ -d ~/.local/bin ]; then
    export PATH=$PATH:~/.local/bin
fi
