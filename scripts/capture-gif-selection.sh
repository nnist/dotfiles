swaymsg mode recording
wf-recorder -g "$(slurp)" -f "$(date +"/tmp/gif_%Y-%m-%d_%H-%M-%S.gif")" -c gif
notify-send -u normal "Gif created!" -t 5000
