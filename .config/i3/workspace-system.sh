if i3-msg -t get_workspaces | grep "5: system"; then
    i3-msg "workspace 5: system"
else
    # Load layout
    i3-msg "workspace 5: system; append_layout ~/.config/i3/system/workspace-system.json"
    
    # Start applications
    (alacritty -d 0 0 --class disk-usage-container -e ".config/i3/system/disk-usage.sh" &)
    (alacritty -d 0 0 --class sensors-container -e ".config/i3/system/sensors.sh" &)
    (alacritty -d 0 0 --class nethogs-container -e ".config/i3/system/nethogs.sh" &)
    (alacritty -d 0 0 --class htop-container -e ".config/i3/system/htop.sh" &)
    (alacritty -d 0 0 --class logs-container -e ".config/i3/system/logs.sh" &)
    (alacritty -d 0 0 --class rss-container -e ".config/i3/system/rss.sh" &)
    (alacritty -d 0 0 --class updates-container -e ".config/i3/system/updates.sh" &)
fi
