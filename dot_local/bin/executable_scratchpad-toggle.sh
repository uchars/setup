#!/usr/bin/env sh
APP_ID="sysscratch"
CMD="$@"

# Find current PID of the app
CURRENT_PID=$(hyprctl clients -j | jq -r ".[] | select(.class==\"$APP_ID\") | .pid // empty")

if [ -n "$CURRENT_PID" ]; then
    if ps -p "$CURRENT_PID" -o args= | grep -q -- "$CMD"; then
        # Kill same app
        kill "$CURRENT_PID" 2>/dev/null
        exit 0
    else
        # Kill other app before spawning next
        kill "$CURRENT_PID" 2>/dev/null
        sleep 0.1
    fi
fi

alacritty --class "$APP_ID" -e $CMD &

# Wait for window and open
for _ in $(seq 1 20); do
    WIN_ID=$(hyprctl clients -j | jq -r ".[] | select(.class==\"$APP_ID\") | .id // empty")
    if [ -n "$WIN_ID" ]; then
        hyprctl dispatch "[id=$WIN_ID] focuswindow"
        exit 0
    fi
    sleep 0.05
done

exit 1

