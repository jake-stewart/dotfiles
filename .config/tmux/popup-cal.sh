#!/bin/bash

client_width=$(tmux display -p "#{client_width}")
client_height=$(tmux display -p "#{client_height}")

width=28
height=12

hex_to_ansi() {
    r=$((16#${1:1:2}))
    g=$((16#${1:3:2}))
    b=$((16#${1:5:2}))
    echo "${r};${g};${b}"
}

session_color="$(tmux showenv session_color | sed 's/session_color=//')"
[ -z "$session_color" ] && session_color=cyan
hex=$(grep "^$session_color" ~/.cache/active_theme | sed 's/^[a-z]* //')
rgb="$(hex_to_ansi $hex)"

tmux display-popup \
    -w $width \
    -h $((height - 1)) \
    -x $(((client_width - width))) \
    -y $(((client_height - 1))) \
    -E \
    -d "$pwd" \
    "printf '\\x1b[?25l'; cal | sed -E 's/^/   /' | sed -E 's/ ('\"\$(date +%d | sed 's/^0/ /')\"') /▐\1▌/g' | GREP_COLOR='1;7;38;2;$rgb' grep -C99 --color=always \"\$(date +%d | sed -E 's/^([1-9])/\\\\b\\1/' | sed 's/^0/ /')\"'\\b' | GREP_COLOR='38;2;$rgb' grep --color=always -E -C99 '(▐|▌)'; printf '\\x1b[T\\x1b[?1002h'; stty -echo; bash -c 'read -n 1'"
