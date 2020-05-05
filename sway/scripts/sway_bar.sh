date_formatted=$(date +'%a %-d %b · %H:%M')

battery_charge=$(upower --show-info $(upower --enumerate | grep 'BAT') | egrep "percentage" | awk '{print $2}')
battery_status=$(upower --show-info $(upower --enumerate | grep 'BAT') | egrep "state" | awk '{print $2}')
battery_icon=''
if [ $battery_status = "discharging" ];
then
    if (( "${battery_charge//%}" < 10)); then
        battery_num=0
    elif (( "${battery_charge//%}" == 100)); then
        battery_num=10
    else
        battery_num="${battery_charge:0:1}"
    fi
    battery_icons=(          )
    battery_icon="${battery_icons[battery_num]}"
    battery_time="$(upower -i $(upower -e | grep 'BAT') | grep "time\ to\ empty" | awk '{print $4 substr ($5, 0, 1)}')"
else
    battery_time="$(upower -i $(upower -e | grep 'BAT') | grep "time\ to\ full" | awk '{print $4 substr ($5, 0, 1)}')"
fi
battery_status="$battery_icon $battery_charge ($battery_time)"

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

echo "$vpn_status vpn · $audio_status · $battery_status · $date_formatted "
