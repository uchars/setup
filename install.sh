#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export ROOT_DIR

source "$ROOT_DIR/scripts/helpers.sh"

DISTRO="$(. /etc/os-release && echo "$ID")"
log "Detected distro: $DISTRO"

case "$DISTRO" in
  arch|cachyos)
    source "$ROOT_DIR/bootstrap/arch.sh"
    ;;
  *)
    log "Unsupported distro: $DISTRO"
    exit 1
    ;;
esac

source "$ROOT_DIR/system/system.sh"
log "Applying dotfiles"
chezmoi init https://github.com/uchars/dotfiles.git

log "Done"

