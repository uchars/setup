#!/usr/bin/env bash
set -euo pipefail

python -m pip install konsave

KONSAVE_FILE="$ROOT_DIR/kde_profiles/desktop.knsv"
if command_exists konsave; then
    if [ -f "$KONSAVE_FILE" ]; then
        konsave -i "$KONSAVE_FILE"
        konsave -a desktop
    else
        log "could not find $KONSAVE_FILE"
    fi
fi

SDDM_CONF="$ROOT_DIR/configs/sddm_autologin.conf"
SDDM_CONF_DIR="/etc/sddm.conf.d"

if command_exists plasmalogin; then
    log "plasmalogin detected"
    if systemctl list-unit-files | grep -q plasmalogin.service; then
        sudo systemctl enable plasmalogin
    fi
    sudo cp "$SDDM_CONF" "/etc/plasmalogin.conf"
elif command_exists sddm; then
    log "sddm detected"
    sudo systemctl enable sddm
    sudo mkdir -p "$SDDM_CONF_DIR"
    sudo cp "$SDDM_CONF" "$SDDM_CONF_DIR/autologin.conf"
else
    log "No supported display manager (sddm or plasmalogin) found"
fi
