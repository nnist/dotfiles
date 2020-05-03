source ~/.config/base16-shell/scripts/base16-default-dark.sh
source ~/.bashrc.d/fzf_utils.bashrc
sleep .02
swaymsg "resize set height 40 ppt"
bash -c 'compgen -c | grep -v fzf | sort -u | fzf --layout=reverse | xargs -r swaymsg -t command exec'
