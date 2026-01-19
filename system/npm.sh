#!/usr/bin/env bash
set -euo pipefail

NVM_DIR="$HOME/.nvm"

if [[ ! -d "$NVM_DIR" ]]; then
    log "Installing NVM (Node Version Manager)..."

    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

else
    log "NVM already installed"
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
fi

if ! command -v node &>/dev/null || ! node -v | grep -q "v"; then
    log "Installing latest LTS Node.js via NVM..."
    nvm install --lts
    nvm use --lts
else
    log "Node.js already installed ($(node -v)), skipping"
fi

