#!/bin/bash

# Render a markdown file and reload Firefox
rendermd()
{
    if [ "$1" ] ; then
        pandoc "$1" \
            --from gfm \
            --to html5 \
            --output ~/Downloads/md-preview.html \
            --standalone \
            --self-contained \
            --highlight-style kate \
            --metadata pagetitle="$1" \
            --css ~/git/dotfiles/bash/github-markdown.css
        local focused_window
        focused_window=$(xdotool getwindowfocus)
        xdotool search \
            --onlyvisible \
            --class "Firefox" windowfocus key \
            --window %@ "ctrl+r" \
            || { 1>&2 echo "unable to signal Firefox"; }
        xdotool windowfocus "$focused_window"
    else
        echo "'$1' is not a valid file!"
    fi
}
export -f rendermd

# Reload a markdown file when it is changed
function hotreloadmd
{
    if [ "$1" ] ; then
        find "$1" | entr -p sh -c "rendermd $1"
    else
        echo "'$1' is not a valid file!"
    fi
}
