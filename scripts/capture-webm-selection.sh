swaymsg mode recording
wf-recorder -g "$(slurp)" -f "$(date +"/tmp/webm_%Y-%m-%d_%H-%M-%S.webm")" -c libvpx -p v=0 -p crf=31
notify-send -u normal "Webm created!" -t 5000
