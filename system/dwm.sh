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
    sudo make install -j$(($(nproc)/2))
    popd >/dev/null

    log "dwm installation complete"
else
    log "dwm already installed, skipping"
fi

if command_exists dwm; then
    log "Registering dwm session for display managers"
    sudo mkdir -p /usr/share/xsessions
    sudo tee /usr/share/xsessions/dwm.desktop >/dev/null <<'EOF'
[Desktop Entry]
Name=dwm
Comment=Dynamic window manager
Exec=dwm
TryExec=dwm
Type=XSession
DesktopNames=dwm
EOF
else
    log "dwm binary not found; skipping display manager session registration"
fi

DWMBLOCKS_DIR="$HOME/work/dwmblocks"
if ! command_exists dwmblocks; then
    log "Installing dwmblocks from source..."

    # clone if not already cloned in temp folder
    if [[ ! -d "$DWMBLOCKS_DIR" ]]; then
        git clone https://github.com/uchars/dwmblocks-async.git "$DWMBLOCKS_DIR"
    fi

    pushd "$DWMBLOCKS_DIR" >/dev/null
    sudo make clean
    sudo make install -j$(($(nproc)/2))
    popd >/dev/null

    log "dwmblocks installation complete"
else
    log "dwmblocks already installed, skipping"
fi

if ! command_exists cargo; then
    curl https://sh.rustup.rs -sSf | sh -s -- -y
    . "$HOME/.cargo/env"
fi
cargo install bluetui
cargo install wiremix
cargo install clock-tui
cargo install alacritty

