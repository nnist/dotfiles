if i3-msg -t get_workspaces | grep "1: tasks"; then
    i3-msg "workspace 1: tasks"
else
    # Load layout
    i3-msg "workspace 1: tasks; append_layout ~/.config/i3/tasks/workspace-tasks.json"
    
    # Start applications
    (alacritty -d 0 0 --class task-summary-container -e ".config/i3/tasks/task-summary.sh" &)
    (alacritty -d 0 0 --class task-calendar-container -e ".config/i3/tasks/task-calendar.sh" &)
    (alacritty -d 0 0 --class vim-journal-container -e ".config/i3/tasks/vim-journal.sh" &)
    (alacritty -d 0 0 --class task-container -e ".config/i3/tasks/tasks.sh" &)
fi
