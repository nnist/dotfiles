alias tma='tmux attach-session -t 0'
alias gitlog='git log --graph --oneline --all --decorate --pretty="%C(bold)%ad%C(reset) %C(yellow)%h%C(reset) %an %C(blue)%s" --date=format:"%y/%m/%d"'
alias steam-wine='wine .wine/drive_c/Program\ Files\ \(x86\)/Steam/Steam.exe >/dev/null 2>&1 &'
alias 'c=xclip -selection clipboard'
alias 'v=xclip -o'
alias tmux-dev='tmux new-session \; \
    send-keys 'vim' C-m \; \
    split-window -h -p 39\; \
    select-pane -t 0 \; \
    split-window -v -p 10\; \
    select-pane -t 0 \;'
