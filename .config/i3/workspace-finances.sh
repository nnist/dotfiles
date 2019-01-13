if i3-msg -t get_workspaces | grep "4: finances"; then
    i3-msg "workspace 4: finances"
else
    # Load layout
    i3-msg "workspace 4: finances; append_layout ~/.config/i3/finances/workspace-finances.json"
    
    # Start applications
    (alacritty --class fava-container -e ".config/i3/finances/fava.sh" &)
    (alacritty --class vim-beancount-container -e ".config/i3/finances/vim-beancount.sh" &)
    (alacritty --class task-container -e ".config/i3/finances/task-finances.sh" &)
    (alacritty --working-directory ~/beancount &)
    sleep 1.0
    (firefox --new-window http://localhost:5000/personal-ledger/balance_sheet/ &)
fi
