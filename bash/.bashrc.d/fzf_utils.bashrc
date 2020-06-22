#!/bin/bash

# Show hidden files by default
export FZF_DEFAULT_COMMAND='rg --files --hidden \
    --no-ignore-vcs -g "!{.git/*,.mypy_cache/*,__pycache__/*}"'
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

alias glNoGraph='git log --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr% C(auto)%an" "$@"'
_gitLogLineToHash="echo {} | grep -o '[a-f0-9]\{7\}' | head -1"
_viewGitLogLine="$_gitLogLineToHash | xargs -I % sh -c 'git show --color=always % | diff-so-fancy'"

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

    num_branches="$(wc -l <<<"$branches")"

    branch="$(
        echo "$branches" |
            fzf-tmux -d "$((2 + "$num_branches"))" +m
    )" || return

    target="$(
        echo "$branch" |
            sed "s/.* //" |
            sed "s#remotes/[^/]*/##"
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
        echo "$commits" |
            fzf --tac +s +m -e
    )" || return

    git checkout "$(echo "$commit" | sed "s/ .*//")"
}

# using ripgrep combined with preview
# find-in-file - usage: fif <searchTerm>
fif() {
    if [ ! "$#" -gt 0 ]; then
        echo "Need a string to search for!"
        return 1
    fi
    rg --files-with-matches --no-messages "$1" | fzf --preview "highlight -O ansi -l {} 2> /dev/null | rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '$1' || rg --ignore-case --pretty --context 10 '$1' {}"
}

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
            --format="%(if)%(HEAD)%(then)%(else)%(if:equals=HEAD)%(refname:strip=3)%(then)%(else)%1B[0;34;1mbranch%09%1B[m%(refname:short)%(end)%(end)" |
            sed '/^$/d'
    ) || return
    tags=$(
        git --no-pager tag | awk '{print "\x1b[35;1mtag\x1b[m\t" $1}'
    ) || return
    target=$(
        (
            echo "$branches"
            echo "$tags"
        ) |
            fzf --no-hscroll --no-multi -n 2 \
                --ansi --preview="git --no-pager log -150 --pretty=format:%s '..{2}'"
    ) || return
    git checkout $(awk '{print $2}' <<<"$target")
}

# fcoc_preview - checkout git commit with previews
fcoc_preview() {
    local commit
    commit=$(glNoGraph |
        fzf --no-sort --reverse --tiebreak=index --no-multi \
            --ansi --preview="$_viewGitLogLine") &&
        git checkout $(echo "$commit" | sed "s/ .*//")
}

# fssh_agent - start new ssh agent and select ssh-key to add
fssh_agent() {
    local keyfile
    keyfile=$(grep -rl "$HOME/.ssh" -e 'BEGIN .*PRIVATE' | fzf)
    if [ "x$keyfile" != "x" ]; then
        eval "$(ssh-agent -s)" &>/dev/null
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
    selection=$(echo "$processes" |
        sed 1d |
        fzf -m --header 'UID          PID    PPID  C STIME TTY          TIME CMD')

    local names
    names=$(echo "$selection" | awk '{print $8}' | sed ':a;N;$!ba;s/\n/'\'', '\''/g')

    local pids
    pids=$(echo "$selection" | awk '{print $2}')
    if [ "x$pids" != "x" ]; then
        if confirm "Please confirm: kill '$names'?"; then
            echo "$pids" | xargs kill "-${1:-9}"
        fi
    fi
}
