#!/bin/bash
set -e

if [ $(tmux display -p "#{window_panes}") = 1 ]; then
    if [ $(tmux display -p "#{window_width}") -ge 140 ]; then
        layout="splitw -h"
    elif [ $(tmux display -p "#{window_height}") -ge 40 ]; then
        layout="splitw"
    fi
fi
if [ "$layout" = "" ]; then
    layout="new-window -n notes"
fi

tmux $layout "$EDITOR ~/Documents/notes/index.md"
