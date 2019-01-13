if i3-msg -t get_workspaces | grep "1: dev"; then
    i3-msg "workspace 1: dev"
else
    # Load layout
    i3-msg "workspace 1: dev; append_layout ~/.config/i3/dev/workspace-dev.json"
    
    # Start applications
    (alacritty --class task-container -e ".config/i3/dev/task-dev.sh" &)
    (alacritty --working-directory ~/git &)
    (alacritty --working-directory ~/git &)
    (firefox --new-window &)
fi
