#!/usr/bin/env bash
set -euo pipefail

WALLPAPER="$ROOT_DIR/wallpapers/foggy_mountain.jpg"
ln -s $WALLPAPER $HOME/.local/wallpaper.jpg

if command_exists feh; then
    if [[ ! -f "$HOME/.fehbg" ]]; then
        log "Setting default wallpaper from setup repo..."
        feh --bg-scale "$WALLPAPER" &>/dev/null || true
    else
        log "Wallpaper file exists, leaving it unchanged"
    fi
else
    log "feh is not installed. Not setting wallpaper"
fi
