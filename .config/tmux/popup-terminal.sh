#!/bin/bash

set -e

color=$(tmux showenv session_color | sed 's/session_color=//' 2>/dev/null);
[ -z "$color" ] && color="brightblack"

last_session="$(tmux display -p '#{session_name}')"

color=${color//#/\\\#} 

command="tmux set status off"
command="$command; tmux set-environment popup_last_session '$last_session'"
command="$command; tmux set-environment session_color '$color'"
command="$command; tmux set detach-on-destroy on"
command="$command; zsh; exit 0"

"$HOME/.config/tmux/popup.sh" "tmux new -As popup '$command'; exit 0"
