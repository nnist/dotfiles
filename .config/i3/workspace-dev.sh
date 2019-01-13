if i3-msg -t get_workspaces | grep "2: dev"; then
    i3-msg "workspace 2: dev"
else
    # Load layout
    i3-msg "workspace 2: dev; append_layout ~/.config/i3/dev/workspace-dev.json"
    
    # Start applications
    (alacritty -d 0 0 --class task-container -e ".config/i3/dev/task-dev.sh" &)
    (alacritty -d 0 0 --working-directory ~/git &)
    (alacritty -d 0 0 --working-directory ~/git &)
    (firefox --new-window &)
fi
