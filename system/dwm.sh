#!/usr/bin/env bash
set -euo pipefail

DWM_DIR="$HOME/work/dwm"
if ! command_exists dwm; then
    log "Installing dwm from source..."

    # clone if not already cloned in temp folder
    if [[ ! -d "$DWM_DIR" ]]; then
        git clone https://github.com/uchars/dwm.git "$DWM_DIR"
    fi

    pushd "$DWM_DIR" >/dev/null
    make clean
    sudo make install
    popd >/dev/null

    log "dwm installation complete"
else
    log "dwm already installed, skipping"
fi

WALLPAPER="$ROOT_DIR/wallpapers/foggy_mountain.jpg"
WALLPAPER_FILE="$HOME/.config/dwm/wallpaper"
if command_exists feh; then
    mkdir -p "$HOME/.config/dwm"

    if [[ ! -f "$WALLPAPER_FILE" ]]; then
        log "Setting default dwm wallpaper from setup repo..."
        echo "$WALLPAPER" > "$WALLPAPER_FILE"
        feh --bg-scale "$WALLPAPER" &>/dev/null || true
    else
        log "Wallpaper file exists, leaving it unchanged"
    fi
else
    log "feh is not installed. Not setting wallpaper"
fi
