#!/usr/bin/env bash

FILE_PATH="$1"
WIDTH="$2"
HEIGHT="$3"
X="$4"
Y="$5"

previewText() {
    bat \
        --color always \
        --theme ansi \
        --style plain \
        --paging never \
        --line-range "1:$HEIGHT" \
        "$1"
}

case $(file --mime-type -Lb "$1") in
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
esac
