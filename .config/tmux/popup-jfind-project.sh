client_width=$(tmux display -p "#{client_width}")
client_height=$(tmux display -p "#{client_height}")

max_width=120
max_height=28

border="-B"
fullscreen() {
    width=$client_width
    height=$client_height
    border="-B"
}

if ((client_width > max_width)); then
    width=$((client_width % 2 ? max_width - 1 : max_width))
    if ((client_height > max_height)); then
        height=$((client_height % 2 ? max_height - 1 : max_height))
    else
        fullscreen
    fi
else
    fullscreen
fi

disable_cursor='echo "\x1b[?25l"'

# tmux display-popup \
#     -w $width \
#     -h $((height - 1)) \
#     -x $(((client_width - width) / 2)) \
#     -E \
#     -d "$(pwd)" \
#     -B \
#     "$disable_cursor; $HOME/.config/jfind/jfind-recursive.sh; $disable_cursor"
