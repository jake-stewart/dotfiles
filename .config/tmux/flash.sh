#!/bin/bash

pidfile="/tmp/tmux_flash"
trap "exit 0" INT TERM EXIT
pid="$(cat $pidfile)" && pkill -P "$pid"
echo "$$" > "$pidfile"

main() {
    echo "set -g pane-active-border-style fg=colour$2"
    sleep 1
    i="$2"
    while [ "$i" -gt "$1" ]
    do
        i=$((i - 1))
        echo "set -g pane-active-border-style fg=colour$i"
        sleep 0.04
    done
    rm -f "$pidfile"
}

main "$1" "$2" | tmux -C attach >/dev/null
