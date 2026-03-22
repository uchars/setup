#!/bin/bash
source "$HOME/.config/alias.sh"

get_ram_usage() {
    total=$(grep MemTotal /proc/meminfo | awk '{print $2}')
    available=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
    used=$((total - available))
    total_mb=$((total / 1024))
    used_mb=$((used / 1024))
    echo "$used_mb/$total_mb MB"
}

while true; do
    BAT_STR=""
    if [[ -d /sys/class/power_supply/BAT0 ]]; then
        BAT_CAPACITY=$(cat /sys/class/power_supply/BAT0/capacity)
        BAT_STATUS=$(cat /sys/class/power_supply/BAT0/status)
        BAT_STR=" | BAT: $BAT_CAPACITY% ($BAT_STATUS)"
    fi

    SOUND_VOLUME=$(amixer sget Master | grep 'Right:' | awk -F'[][]' '{ print $2 }')
    SOUND_MUTED=$(amixer sget Master | grep 'Right:' | awk -F'[][]' '{ print $4 }')
    if [ "$SOUND_MUTED" = "off" ]; then
        SOUND_MUTED="(muted)"
    else
        SOUND_MUTED=""
    fi

    SPOTIFY_STR=""
    SERVICE="org.mpris.MediaPlayer2.spotify"
    if dbus-send --print-reply --type=method_call --dest=$SERVICE /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:org.mpris.MediaPlayer2 string:Identity >/dev/null 2>/dev/null; then
        SPOTIFY_STATE=$(dbus-send --print-reply --dest=$SERVICE /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'PlaybackStatus' | grep -oE '(Playing|Paused)')
        SPOTIFY_TITLE=$(dbus-send --print-reply --dest=$SERVICE /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:org.mpris.MediaPlayer2.Player string:Metadata | sed -n '/title/{n;p}' | cut -d \" -f 2)
        SPOTIFY_STR="($SPOTIFY_STATE) $SPOTIFY_TITLE |"
    fi

    xsetroot -name "$SPOTIFY_STR VOL: $SOUND_VOLUME$SOUND_MUTED | RAM: $(get_ram_usage)$BAT_STR | $(date)"

    sleep 1
done

