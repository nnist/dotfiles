# Load layout
i3-msg "workspace 4; append_layout ~/.config/i3/webdev/workspace-webdev.json"

# Start applications
(alacritty --class task-container -e ".config/i3/webdev/task-webdev.sh" &)
(alacritty --working-directory ~/git &)
(alacritty --working-directory ~/git &)
(firefox --new-window &)
