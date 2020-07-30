HIST_FILE="$HOME/git/dotfiles/rofi/.workspace_name_history"

# Create history file if it doesn't exist
if [ ! -f "$HIST_FILE" ]; then
    touch "$HIST_FILE"
fi

# Find the current workspace number
ws_num=$(swaymsg -t get_workspaces | jq '.[] | select(.focused==true).name' | cut -d"\"" -f2 | cut -d " " -f1)

# Input name
ws_name=$(rofi -input "$HIST_FILE" -dmenu -theme base16-default-dark -p "Assign name")
if [ "x$ws_name" == "x" ]; then
    exit 0
fi

# Rename workspace
swaymsg rename workspace to "$ws_num · $ws_name"

# Add workspace name to history
if ! grep "$ws_name" "$HIST_FILE"; then
    echo "$ws_name" >>"$HIST_FILE"
fi
