# TODO Change linux term (TTY) colors to base16

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

HISTCONTROL=ignoreboth # Ignore duplicate lines and lines starting with space
shopt -s histappend # Append history; don't overwrite
HISTSIZE=1000
HISTFILESIZE=2000

shopt -s checkwinsize # Prevent terminal window from messing up

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# Alias definitions
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Enable programmable completion features
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# Custom prompt
export PS1="\[$(tput setaf 3)\]\u\[$(tput setaf 7)\]@\[$(tput setaf 3)\]\h \[$(tput setaf 4)\]\w \[$(tput setaf 7)\]>\[$(tput sgr0)\] "

# Base16-shell
BASE16_SHELL=$HOME/.config/base16-shell/
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"

function extract() # Extract program
{
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xvjf $1     ;;
            *.tar.gz)    tar xvzf $1     ;;
            *.bz2)       bunzip2 $1      ;;
            *.rar)       unrar x $1      ;;
            *.gz)        gunzip $1       ;;
            *.tar)       tar xvf $1      ;;
            *.tbz2)      tar xvjf $1     ;;
            *.tgz)       tar xvzf $1     ;;
            *.zip)       unzip $1        ;;
            *.Z)         uncompress $1   ;;
            *.7z)        7z x $1         ;;
            *)           echo "'$1' cannot be extracted via >extract<" ;;
        esac
    else
        echo "'$1' is not a valid file!"
	fi
}

function maketar() # Create a tar archive
{
    tar cvzf "${1%%/}.tar.gz"  "${1%%/}/";
}

function makezip() # Create a zip archive
{
    zip -r "${1%%/}.zip" "$1";
}

function mdpreview() # Render .md to html for previewing in browser
{
    if [ $1 ] ; then
        pandoc $1 --from gfm --to html5 --output /tmp/md-preview.html --standalone --self-contained --highlight-style kate --css ~/git/dotfiles/github-markdown.css
    else
        echo "'$1' is not a valid file!"
    fi
}

function netinfo() # Display network information
{
    echo "--------------- Network Information ---------------"
    external_ip=`curl -s checkip.dyndns.org | sed -e 's/.*Current IP Address: //' -e 's/<.*$//'`
    local_ip=`ip -c -br a`
    
    echo -e "External IP address:\n${external_ip}\n"
    echo -e "Local IP addresses:\n${local_ip}\n"
    echo "---------------------------------------------------"
} 

function calc() # Simple calculator function
{
    if which bc &>/dev/null; then
        echo "scale=3; $*" | bc -l
    else
        awk "BEGIN { print $* }"
    fi
}
