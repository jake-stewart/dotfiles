#!/bin/bash

FILE_NAME="$1"
WIDTH="$2"
HEIGHT="$3"
H_POSITION="$4"
V_POSITION="$5"
NEXT_FILE="$^"

eraseTilEOL() {
    printf "\x1b[0K" > /dev/tty
}

moveCursor() {
    printf "\x1b[$1;$2H" > /dev/tty
}

moveCursorDown() {
    printf "\x1b[$1B" > /dev/tty
}

for i in $(seq "$HEIGHT"); do
    moveCursor "$((V_POSITION + i))" "$((H_POSITION))"
    eraseTilEOL
done

