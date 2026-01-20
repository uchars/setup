#!/usr/bin/env bash
set -euo pipefail

ENABLE_NVIDIA=false

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export ROOT_DIR

source "$ROOT_DIR/scripts/helpers.sh"

for arg in "$@"; do
    case "$arg" in
        --nvidia)
        log "enable nvidia support"
        ENABLE_NVIDIA=true
        ;;
    esac
done
export ENABLE_NVIDIA

DISTRO="$(. /etc/os-release && echo "$ID")"
log "Detected distro: $DISTRO"

case "$DISTRO" in
  arch|cachyos)
    source "$ROOT_DIR/bootstrap/arch.sh" | tee bootstrap.log
    ;;
  *)
    log "Unsupported distro: $DISTRO"
    exit 1
    ;;
esac

source "$ROOT_DIR/system/system.sh"
source "$ROOT_DIR/system/plymouth.sh"
source "$ROOT_DIR/system/dwm.sh"
source "$ROOT_DIR/system/wallpaper.sh"
source "$ROOT_DIR/system/npm.sh"
source "$ROOT_DIR/system/nvim.sh"
log "Applying dotfiles"
chezmoi init --apply https://github.com/uchars/.files.git

log "Done"

