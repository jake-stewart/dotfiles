#!/usr/bin/env bash

previewText() {
    # clp "$1"
    # bat --color=always --style=plain --theme=ansi "$1"
    bat --color always --theme custom --style plain --paging never "$1"
    # ccat --color=always "$1"
}

case $(file --mime-type -Lb "$1") in
    text/* | application/json)
        previewText "$1"
        ;;
esac
