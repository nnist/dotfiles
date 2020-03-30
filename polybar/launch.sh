#!/usr/bin/env sh

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done



dpi=96
height=26
tray_scale=1.0



# Set proper scale
# height=$(xrandr | awk 'NR==1' | awk -F ',' '{print $2}' | awk -F 'x ' '{print $2}')
# if (($height > 1100)); then
#     dpi=192
#     height=52
#     tray_scale=2.0
# else
#     dpi=96
#     height=26
#     tray_scale=1.0
# fi

# Launch bar on all monitors
if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m DPI=$dpi HEIGHT=$height TRAY_SCALE=$tray_scale polybar -c ~/.config/polybar/config.ini --reload main &
  done
else
  polybar --reload main -c ~/.config/polybar/config.ini &
fi
