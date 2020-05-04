date_formatted=$(date +'%H:%M · %a %-d %b')

battery_charge=$(upower --show-info $(upower --enumerate | grep 'BAT') | egrep "percentage" | awk '{print $2}')
battery_status=$(upower --show-info $(upower --enumerate | grep 'BAT') | egrep "state" | awk '{print $2}')

battery_icon=''
if [ $battery_status = "discharging" ];
then
    battery_icon=''
fi

echo "$battery_icon $battery_charge · $date_formatted "
