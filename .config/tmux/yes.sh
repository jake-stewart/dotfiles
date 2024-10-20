identifier="$1"
pidfile="/tmp/tmux_yes_$identifier"

if [ -e "$pidfile" ]; then
    pid=$(cat "$pidfile")
    rm "$pidfile"
    if ps -p $pid | grep "yes\\.sh" > /dev/null; then
        kill $pid
        exit 0
    fi
fi

echo $$ > "$pidfile"
trap 'rm -f "$pidfile"; exit' INT TERM EXIT

while tmux send-keys -t "$1" Enter; do
    sleep 1
done
