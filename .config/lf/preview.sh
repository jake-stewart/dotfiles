#!/usr/bin/env bash

previewText() {
    bat --color=always --style=plain --theme=ansi "$1"
}

case $(file --mime-type -Lb "$f") in
    text/* \
    | application/json)
        previewText "$1"
        ;;
esac
