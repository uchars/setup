#!/usr/bin/env bash
set -euo pipefail

NVIM_DIR="$HOME/work/neovim"
NVIM_BRANCH="release-0.10"
if ! command_exists cmake; then
    log "cmake not installed"
    exit 0
fi

if ! command_exists nvim; then
    log "Installing Neovim ($NVIM_BRANCH) from source..."

    # clone if not already cloned
    if [[ ! -d "$NVIM_DIR" ]]; then
        git clone --branch "$NVIM_BRANCH" https://github.com/neovim/neovim.git "$NVIM_DIR"
    fi

    pushd "$NVIM_DIR" >/dev/null
    git fetch origin
    git checkout "$NVIM_BRANCH"

    make clean
    make CMAKE_BUILD_TYPE=Release -j$(nproc)
    sudo make install

    log "Neovim installation complete"
else
    log "Neovim already installed, skipping"
fi

