#!/bin/sh
LAYOUT1="us"
LAYOUT2="de"

current=$(setxkbmap -query | awk '/layout:/ {print $2}')

if [ "$current" = "$LAYOUT1" ]; then
    setxkbmap "$LAYOUT2"
else
    setxkbmap "$LAYOUT1"
fi

DWMBLOCKS_SIGNAL=2
if pgrep -x dwmblocks >/dev/null 2>&1; then
    setsid -w pkill -RTMIN+$DWMBLOCKS_SIGNAL dwmblocks >/dev/null 2>&1
fi
