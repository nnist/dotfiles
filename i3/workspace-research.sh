if i3-msg -t get_workspaces | grep "7: research"; then
    i3-msg "workspace 7: research"
else
    # Load layout
    i3-msg "workspace 7: research; append_layout ~/.config/i3/research/workspace-research.json"
    
    # Start applications
    (alacritty -d 0 0 --class task-container -e ".config/i3/research/task-research.sh" &)
    (alacritty -d 0 0 --working-directory ~/syncthing/research &)
    (firefox --new-window &)
    i3-msg "workspace 7: research; exec .config/i3/research/pdf-reader.sh"
fi
