date_formatted=$(date +'%a %-d %b · %H:%M')

battery_charge=$(upower --show-info $(upower --enumerate | grep 'BAT') | egrep "percentage" | awk '{print $2}')
battery_status=$(upower --show-info $(upower --enumerate | grep 'BAT') | egrep "state" | awk '{print $2}')

battery_icon=''
if [ $battery_status = "discharging" ];
then
    battery_icon=''
fi

vpn_status=''
if [ -d "/proc/sys/net/ipv4/conf/tun0" ]; then
    vpn_status=''
fi

audio_raw=$(amixer sget Master | grep 'Right:')
audio_status="婢"
if [ $(echo $audio_raw | awk -F'[][]' '{ print $4 }') = "on" ]; then
    audio_volume=$(echo $audio_raw | awk -F'[][]' '{ print $2 }')
    audio_status="墳 $audio_volume"
fi

echo "$vpn_status vpn · $audio_status · $battery_icon $battery_charge · $date_formatted "
