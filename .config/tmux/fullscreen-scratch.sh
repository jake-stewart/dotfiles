#!/bin/bash
set -e

forceOwnWindow="$1"

if [ -z "$forceOwnWindow" ]; then
    if [ $(tmux display -p "#{pane_width}") = $(tmux display -p "#{window_width}") ]; then
        if [ $(tmux display -p "#{window_width}") -ge 160 ]; then
            layout="splitw -h -l 80"
        fi
    fi
    if [ -z "$layout" ]; then
        if [ $(tmux display -p "#{pane_height}") -ge 40 ]; then
            layout="splitw"
        fi
    fi
fi

if [ -z "$layout" ]; then
    layout="new-window -n notes"
fi

tmux $layout -c ~/Documents/notes "$EDITOR ~/Documents/notes/index.md"
