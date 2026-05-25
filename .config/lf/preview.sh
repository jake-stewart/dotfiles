#!/usr/bin/env bash

FILE_PATH="$1"
WIDTH="$2"
HEIGHT="$3"
X="$4"
Y="$5"

previewText() {
    syntax_fname="$1"
    [[ "$syntax_fname" == *.json5 ]] && syntax_fname="$1.js"
    head -c 16384 "$1" | bat \
        --color always \
        --theme ansi \
        --style plain \
        --paging never \
        --italic-text always \
        --tabs 4 \
        --line-range "1:$HEIGHT" \
        --file-name "$syntax_fname"
        # --terminal-width "$WIDTH"
        # --wrap character
}

mime_type="$(file --mime-type -Lb "$1")"
case "$mime_type" in
    # text/plain)
    #     head -n "$HEIGHT" "$1"
    #     ;;
    text/* | application/json)
        previewText "$1"
        ;;
    # image/*)
    #     ~/.config/tmux/popup-image.py preview \
    #         "$FILE_PATH" \
    #         "$WIDTH" \
    #         "$HEIGHT" \
    #         "$X" \
    #         "$Y"
    #     ;;
    *)
        echo -e "\x1b[3m$mime_type\x1b[0m"
        ;;
esac
