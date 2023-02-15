#!/bin/bash
set -e

OUTPUT="$HOME/.cache/jfind_out"
[ -f "$OUTPUT" ] && rm "$OUTPUT"

read_sources() {
    sed '/^$/d' ~/.config/jfind/sources
}

jfind_command() {
    jfind \
        --hints \
        --select-hint \
        --history=~/.cache/jfind-history/sources
}

read_sources | jfind_command | tee "$OUTPUT"
