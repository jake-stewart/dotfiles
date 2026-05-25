selected="$(tmux display -p '#S')"
color=$(awk '/^'"$selected"' /{print $2}' "$CONF")
tmux set-environment session_color "$color"
