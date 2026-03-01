#!/usr/bin/env bash
set -euo pipefail

# Uses `command_exists` from scripts/helpers.sh (install.sh sources it before this file)
NVM_DIR="$HOME/.nvm"

if [[ ! -d "$NVM_DIR" ]]; then
    log "Installing NVM (Node Version Manager)..."

    if command_exists curl; then
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash || { log "NVM install script failed"; return 0; }
    else
        log "curl not available; cannot install NVM automatically"
        return 0
    fi

    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

else
    log "NVM already installed"
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
fi

if ! command_exists node; then
    log "Installing latest LTS Node.js via NVM..."
    if command_exists nvm; then
        nvm install --lts || log "nvm install failed"
        nvm use --lts || log "nvm use failed"
    else
        log "nvm not available after install; skipping Node.js install"
    fi
else
    NODE_VER="$(node -v 2>/dev/null || echo "")"
    if [[ -n "$NODE_VER" ]]; then
        log "Node.js already installed ($NODE_VER), skipping"
    else
        log "Node present but version check failed; attempting to install LTS via nvm"
        command_exists nvm && nvm install --lts || log "nvm not available; skipping"
    fi
fi

