# TODO Adjust alacritty text size to make more readable on 2x scaling
# TODO Remove debug titles and marks

ws_num="4"
ws_name="dev"
delay=.2
long_delay=1.0

swaymsg workspace "$ws_num"
swaymsg rename workspace to "$ws_num · $ws_name"

swaymsg layout splith

firejail --private=~/firejails/firefox-dev firefox --no-remote &> /dev/null &
sleep $long_delay
swaymsg border normal
swaymsg mark num_0

alacritty &> /dev/null &
sleep $delay
swaymsg border normal
swaymsg mark num_1

~/git/dotfiles/scripts/vimwiki-dark &
sleep $delay
swaymsg border normal
swaymsg mark num_2

swaymsg splitv

alacritty &> /dev/null &
sleep $delay
swaymsg border normal
swaymsg mark num_3

alacritty &> /dev/null &
sleep $delay
swaymsg border normal
swaymsg mark num_4
swaymsg resize set height 30 ppt
