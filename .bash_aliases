alias ls='ls -h --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias tma='tmux attach-session -t 0'
alias gitlog='git log --graph --oneline --all --decorate --pretty="%C(bold)%ad%C(reset) %C(yellow)%h%C(reset) %an %C(blue)%s" --date=format:"%y/%m/%d"'
alias steam-wine='wine .wine/drive_c/Program\ Files\ \(x86\)/Steam/Steam.exe >/dev/null 2>&1 &'
alias 'c=xclip -selection clipboard'
alias 'v=xclip -o'
alias tmux-dev='tmux new-session \; \
    send-keys 'vim' C-m \; \
    split-window -h -p 39\; \
    split-window -v -p 1\; \
    select-pane -t 0 \;'
alias ports="netstat -tulpn" # List open ports and programs which use them
alias lock="i3lock -c 181818 -e -f"
