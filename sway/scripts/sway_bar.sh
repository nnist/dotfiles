date_formatted=$(date +'%a %-d %b · %H:%M')

battery_raw=$(upower --show-info $(upower --enumerate | grep 'BAT'))
battery_charge=$(echo "$battery_raw" | egrep "percentage" | awk '{print $2}')
battery_status=$(echo "$battery_raw" | egrep "state" | awk '{print $2}')

if (( "${battery_charge//%}" < 10)); then
    battery_num=0
elif (( "${battery_charge//%}" == 100)); then
    battery_num=10
else
    battery_num="${battery_charge:0:1}"
fi
battery_icons=(          )
battery_icon="${battery_icons[battery_num]}"
battery_charge_icon=""

if [ $battery_status = "discharging" ];
then
    battery_time="$(echo "$battery_raw" | grep "time\ to\ empty" | awk '{print $4 substr ($5, 0, 1)}')"
else
    battery_charge_icon=""
    battery_time="$(echo "$battery_raw" | grep "time\ to\ full" | awk '{print $4 substr ($5, 0, 1)}')"
fi
battery_status="$battery_charge_icon$battery_icon $battery_charge ($battery_time)"

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

if pgrep -x swayidle &>/dev/null; then
    swayidle_status=""
else
    swayidle_status=" autolock off ·"
fi

echo "$swayidle_status $vpn_status vpn · $audio_status · $battery_status · $date_formatted "
