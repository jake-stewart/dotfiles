#!/bin/bash

CONFIG="$XDG_CONFIG_HOME"
[ -z "$CONFIG" ] && CONFIG="$HOME/.config"
TMUX_CONFIG="$CONFIG/tmux"

executable="$TMUX_CONFIG/tmux_flash"

[ ! -e "$executable" ] && cd "$TMUX_CONFIG" \
    && gcc -O3 -o tmux_flash tmux_flash.c

"$executable" "$@"
# true
