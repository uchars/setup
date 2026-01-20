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
    sudo make install -j$(nproc)
    popd >/dev/null

    log "dwm installation complete"
else
    log "dwm already installed, skipping"
fi
