#!/usr/bin/env bash
set -euo pipefail

KONSAVE_FILE="$ROOT_DIR/kde_profiles/desktop.knsv"
if command_exists konsave; then
    if [ -f "$KONSAVE_FILE" ]; then
        konsave -i "$KONSAVE_FILE"
        konsave -a desktop
    else
        log "could not find $KONSAVE_FILE"
    fi
fi

sudo systemctl enable sddm

SDDM_CONF="$ROOT_DIR/configs/sddm_autologin.conf"
SDDM_CONF_DIR="/etc/sddm.conf.d"
sudo mkdir -p $SDDM_CONF_DIR
sudo cp "$SDDM_CONF" "$SDDM_CONF_DIR/autologin.conf"
