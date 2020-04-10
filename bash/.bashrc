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
            --metadata pagetitle="$1" \
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

# fbr - checkout git branch (including remote branches)
#   - sorted by most recent commit
#   - limit 30 last branches
fbr() {
  local branches
  local num_branches
  local branch
  local target

  branches="$(
    git for-each-ref \
      --count=30 \
      --sort=-committerdate \
      refs/heads/ \
      --format='%(refname:short)'
  )" || return

  num_branches="$(wc -l <<< "$branches")"

  branch="$(
    echo "$branches" \
      | fzf-tmux -d "$((2 + "$num_branches"))" +m
  )" || return

  target="$(
    echo "$branch" \
      | sed "s/.* //" \
      | sed "s#remotes/[^/]*/##"
  )" || return

  git checkout "$target"
}

# fcoc - checkout git commit
fcoc() {
  local commits
  local commit

  commits="$(
    git log --pretty=oneline --abbrev-commit --reverse
  )" || return

  commit="$(
    echo "$commits" \
      | fzf --tac +s +m -e
  )" || return

  git checkout "$(echo "$commit" | sed "s/ .*//")"
}

# using ripgrep combined with preview
# find-in-file - usage: fif <searchTerm>
fif() {
  if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi
  rg --files-with-matches --no-messages "$1" | fzf --preview "highlight -O ansi -l {} 2> /dev/null | rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '$1' || rg --ignore-case --pretty --context 10 '$1' {}"
}

alias glNoGraph='git log --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr% C(auto)%an" "$@"'
_gitLogLineToHash="echo {} | grep -o '[a-f0-9]\{7\}' | head -1"
_viewGitLogLine="$_gitLogLineToHash | xargs -I % sh -c 'git show --color=always % | diff-so-fancy'"


# fshow_preview - git commit browser with previews
fshow_preview() {
    glNoGraph |
        fzf --no-sort --reverse --tiebreak=index --no-multi \
            --ansi --preview="$_viewGitLogLine" \
                --header "enter to view, alt-y to copy hash" \
                --bind "enter:execute:$_viewGitLogLine   | less -R" \
                --bind "alt-y:execute:$_gitLogLineToHash | xclip"
}

# fco_preview - checkout git branch/tag, with a preview showing the commits between the tag/branch and HEAD
fco_preview() {
  local tags branches target
  branches=$(
    git --no-pager branch --all \
      --format="%(if)%(HEAD)%(then)%(else)%(if:equals=HEAD)%(refname:strip=3)%(then)%(else)%1B[0;34;1mbranch%09%1B[m%(refname:short)%(end)%(end)" \
    | sed '/^$/d') || return
  tags=$(
    git --no-pager tag | awk '{print "\x1b[35;1mtag\x1b[m\t" $1}') || return
  target=$(
    (echo "$branches"; echo "$tags") |
    fzf --no-hscroll --no-multi -n 2 \
        --ansi --preview="git --no-pager log -150 --pretty=format:%s '..{2}'") || return
  git checkout $(awk '{print $2}' <<<"$target" )
}

# fcoc_preview - checkout git commit with previews
fcoc_preview() {
  local commit
  commit=$( glNoGraph |
    fzf --no-sort --reverse --tiebreak=index --no-multi \
        --ansi --preview="$_viewGitLogLine" ) &&
  git checkout $(echo "$commit" | sed "s/ .*//")
}

# quickcommit - quickly create a git commit, for when message does not matter
quickcommit() {
    if [[ $(git status --porcelain) ]]; then
        if confirm "Are you sure you want to create an autocommit?"; then
            git add .
            git commit -m 'Autocommit'
            git push
        fi
    else
        echo "No changes to commit."
    fi
}

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
            Y*|y*) return 0 ;;
            N*|n*) return 1 ;;
        esac

    done
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

# Show hidden files by default
export FZF_DEFAULT_COMMAND='find .'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND"

export BAT_THEME="base16"

_gen_fzf_default_opts() {
    local color00='#181818'
    local color01='#282828'
    local color02='#383838'
    local color03='#585858'
    local color04='#b8b8b8'
    local color05='#d8d8d8'
    local color06='#e8e8e8'
    local color07='#f8f8f8'
    local color08='#ab4642'
    local color09='#dc9656'
    local color0A='#f7ca88'
    local color0B='#a1b56c'
    local color0C='#86c1b9'
    local color0D='#7cafc2'
    local color0E='#ba8baf'
    local color0F='#a16946'
    
    export FZF_DEFAULT_OPTS="
      --color=bg+:$color01,bg:$color00,spinner:$color0C,hl:$color0D
      --color=fg:$color04,header:$color0D,info:$color0A,pointer:$color0C
      --color=marker:$color0C,fg+:$color06,prompt:$color0A,hl+:$color0D
    "
}

_gen_fzf_default_opts

# fssh_agent - start new ssh agent and select ssh-key to add
fssh_agent() {
    local keyfile
    keyfile=$(grep -rl "$HOME/.ssh" -e 'BEGIN .*PRIVATE' | fzf)
    if [ "x$keyfile" != "x" ]; then
        eval "$(ssh-agent -s)" &> /dev/null
        ssh-add "$keyfile"
    fi
}

# fkill - kill processes
fkill() {
    local processes
    if [ "$UID" != "0" ]; then
        processes=$(ps -f -u $UID)
    else
        processes=$(ps -ef)
    fi

    local selection
    selection=$(echo "$processes" |\
                sed 1d |\
                fzf -m --header 'UID          PID    PPID  C STIME TTY          TIME CMD')

    local names
    names=$(echo "$selection" | awk '{print $8}' | sed ':a;N;$!ba;s/\n/'\'', '\''/g')

    local pids
    pids=$(echo "$selection" | awk '{print $2}')
    if [ "x$pids" != "x" ]; then
        if confirm "Please confirm: kill '$names'?" ; then
            echo "$pids" | xargs kill "-${1:-9}"
        fi
    fi
}
