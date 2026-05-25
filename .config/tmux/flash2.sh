#!/bin/bash

trap "exit 0" INT TERM EXIT

doShit() {
    # existing=$(ps -e | grep "$1" | grep -v grep | awk '{print($1)}')
    # if [ "$?" = 0 ]; then
    #     for id in $existing; do
    #         if [ $id != $$ ]; then
    #             kill $id;
    #         fi
    #     done
    # fi
}

main() {
    # echo "set -g pane-active-border-style fg=colour$2"

    # doShit "$3" &>/dev/null

    echo "set -g pane-active-border-style fg=colour$2"
    sleep 1
    i="$2"
    while [ "$i" -gt "$1" ]
    do
        i=$((i - 1))
        echo "set -g pane-active-border-style fg=colour$i"
        sleep 0.04
    done
}

# terminal-notifier -title "hello" -message "world"
main "$1" "$2" "$0" | tmux -C attach >/dev/null
