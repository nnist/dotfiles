grim -g "$(slurp)" $(date +"/tmp/screenshot_%Y-%m-%d_%H-%M-%S.png")
notify-send -u normal "Screenshot created!" -t 5000
