#!/bin/bash
set -e

disable_cursor='echo "\x1b[?25l"'

"$HOME/.config/tmux/popup.sh" "$disable_cursor; $HOME/.config/jfind/jfind-tmux-complete.sh '$1' --external-border; $disable_cursor" "-B"
