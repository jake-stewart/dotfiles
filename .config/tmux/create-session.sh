#!/bin/bash
set -e

function main() {
    CONF="$HOME/.config/tmux/sessions"

    expand_home() {
        echo "${1/\~/$HOME}"
    }

    selected="$1"
    dest=$(awk '/^'"$selected"' /{print $3}' "$CONF")
    dest=$(expand_home "$dest")

    window_file="$HOME/.config/tmux/session_windows/$selected"

    if [ -f "$window_file" ]; then
        IFS=$'\n'
        set -f
        for line in $(cat < "$window_file");
        do
            eval "arr=($line)"
            name="${arr[0]}"
            path="${arr[1]}"
            [ -z "$path" ] && path="$name"

            if [ "${path::1}" = "/" -o "${path::1}" = "~" ]; then
                path=$(expand_home "$path")
            else
                path="$dest/$path"
            fi

            if [ -z "$first" ]; then
                first=1
                echo new-session -s "$selected" -n "$name" -c "$dest" -d \
                    "bash -c 'cd \"$dest\" || echo; cd \"$path\" || echo; $SHELL'"
            else
                echo new-window -n "$name" -t "$selected" -d \
                    "bash -c 'cd \"$dest\" || echo; cd \"$path\" || echo; $SHELL'"
            fi

            if [ "${#arr[@]}" -le 3 ]; then
                split="-h"
            fi

            for ((i = 2; i < "${#arr[@]}"; i++)); do
                window="${arr[i]}"
                echo split-window -t "$selected:$name.bottom-right" $split -d \
                    "bash -c 'cd \"$dest\" || echo; cd \"$dest/$window\" || echo; $SHELL'"
            done

            if [ "${#arr[@]}" -gt 3 ]; then
                echo select-layout -t "$selected:$name" main-vertical
            fi

        done
    fi
    if [ -z "$first" ]; then
        echo new-session -s "$selected" -c "$dest" -d \
            "bash -c 'cd $dest || echo; $SHELL'"
    fi
}

main "$@" | tmux -C attach >/dev/null
