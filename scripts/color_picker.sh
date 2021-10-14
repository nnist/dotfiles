# Grab a selection and encode it with base64 to easily pass it on
selection=$(grim -g "$(slurp)" - | base64 -)

# Get the average background color
color_hex=$(echo "$selection" |
    base64 --decode - |
    convert -resize 1x1 - txt:- |
    awk 'FNR==2{print substr($3,2)}')

echo "#$color_hex" | wl-copy -n

if [ "x$color_hex" == "x" ]; then
    notify-send -u normal "color_picker.sh" "\nUnable to determine color." -t 10000
    exit 1
fi

msg="
⌌  <span foreground='#$color_hex'>▁▁▁▁▁▁▁▁▁</span>  ⌍
   <b><span foreground='#$color_hex'> #A1FB1G </span></b>
⌎  <span foreground='#$color_hex'>▔▔▔▔▔▔▔▔▔</span>  ⌏
"
notify-send -u normal "color_picker.sh" "$msg"
