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

echo "$vpn_status vpn · $battery_icon $battery_charge · $date_formatted "
