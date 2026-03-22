#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$ROOT_DIR/scripts/helpers.sh"

if ! command_exists fvm; then
    log "installing fvm"
    curl -fsSL https://fvm.app/install.sh | bash
else
    log "fvm already installed"
fi

