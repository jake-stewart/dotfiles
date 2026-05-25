#!/bin/bash

client_width=$(tmux display -p "#{client_width}")
client_height=$(tmux display -p "#{client_height}")

width=20
height=5

tmux display-popup \
    -w $((width)) \
    -h $((height)) \
    -x $(((client_width / 2) - (width / 2))) \
    -y $(((client_height / 2) - (height / 2))) \
    -E \
    -d "$pwd" \
    "python3 ~/.config/tmux/lock.py --no-restore"
