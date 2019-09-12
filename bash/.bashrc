# TODO Change linux term (TTY) colors to base16

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

HISTCONTROL=ignoreboth # Ignore duplicate lines and lines starting with space
shopt -s histappend # Append history; don't overwrite
HISTSIZE=1000
HISTFILESIZE=2000
HISTIGNORE="clear:exit*:poweroff*:reboot*:git checkout*"

shopt -s checkwinsize # Prevent terminal window from messing up
export EDITOR=vim # Set default editor to vim

# Use dircolors
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

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

# Custom prompt
export PS1="\[$(tput setaf 3)\]\u\[$(tput setaf 7)\]@\[$(tput setaf 3)\]\h \[$(tput setaf 4)\]\w \[$(tput setaf 7)\]>\[$(tput sgr0)\] "

# Base16-shell
BASE16_SHELL=$HOME/.config/base16-shell/
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"

function extract()
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

function maketar()
{
    tar cvzf "${1%%/}.tar.gz"  "${1%%/}/";
}

function makezip()
{
    zip -r "${1%%/}.zip" "$1";
}

function netinfo()
{
    echo "--------------- Network Information ---------------"
    external_ip=`curl -s checkip.dyndns.org | sed -e 's/.*Current IP Address: //' -e 's/<.*$//'`
    local_ip=`ip -c -br a`
    
    echo -e "External IP address:\n${external_ip}\n"
    echo -e "Local IP addresses:\n${local_ip}\n"
    echo "---------------------------------------------------"
} 

function calc()
{
    if which bc &>/dev/null; then
        echo "scale=3; $*" | bc -l
    else
        awk "BEGIN { print $* }"
    fi
}

function dirsize()
{
	du -k --max-depth=1 "$@" | sort -nr | awk '
    BEGIN {
       split("KB,MB,GB,TB", Units, ",");
    }
    {
       u = 1;
       while ($1 >= 1024) {
          $1 = $1 / 1024;
          u += 1
       }
       $1 = sprintf("%.1f %s", $1, Units[u]);
       print $0;
    }
    ' | column -t
}

# Codi
# Usage: codi [filetype] [filename]
codi() {
  local syntax="${1:-python}"
  shift
  vim -c \
    "let g:startify_disable_at_vimenter = 1 |\
    let g:ale_python_mypy_options = '--ignore-missing-imports' |\
    set ls=0 noru nornu |\
    hi ColorColumn ctermbg=NONE |\
    hi VertSplit ctermbg=NONE |\
    hi NonText ctermfg=0 |\
    Codi $syntax" "$@"
}

# Render a markdown file and reload Firefox
rendermd()
{
    if [ "$1" ] ; then
        pandoc "$1" \
            --from gfm \
            --to html5 \
            --output ~/Downloads/md-preview.html \
            --standalone \
            --self-contained \
            --highlight-style kate \
            --css ~/git/dotfiles/bash/github-markdown.css
        local focused_window
        focused_window=$(xdotool getwindowfocus)
        xdotool search \
            --onlyvisible \
            --class "Firefox" windowfocus key \
            --window %@ "ctrl+r" \
            || { 1>&2 echo "unable to signal Firefox"; }
        xdotool windowfocus "$focused_window"
    else
        echo "'$1' is not a valid file!"
    fi
}
export -f rendermd

# Reload a markdown file when it is changed
function hotreloadmd
{
    if [ "$1" ] ; then
        find "$1" | entr -p sh -c "rendermd $1"
    else
        echo "'$1' is not a valid file!"
    fi
}

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
fi

eval "$(pyenv virtualenv-init -)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Add FZF key bindings and completions
source /usr/share/fzf/key-bindings.bash
source /usr/share/fzf/completion.bash
