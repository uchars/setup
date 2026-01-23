#!/usr/bin/env bash
set -euo pipefail

log "System configuration"

if grep -q '^#en_US.UTF-8 UTF-8' /etc/locale.gen; then
  log "Configuring locale"
  sudo sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
  sudo locale-gen
fi

# ---- services ------------------------------------------------

enable_service() {
  sudo systemctl is-enabled "$1" &>/dev/null || sudo systemctl enable "$1"
}

enable_service NetworkManager
enable_service bluetooth
enable_service cups
enable_service pcscd

git config --global user.name "Nils"
git config --global user.email "40796807+uchars@users.noreply.github.com"

log "Rebuilding font cache"
fc-cache -fv &>/dev/null || true

if command_exists docker; then
    sudo systemctl enable --now docker
    sudo usermod -aG docker "$USER"
fi

if [[ "${ENABLE_NVIDIA:-false}" == "true" ]]; then
    log "configure nvidia in mkinitcpio"
    MKINIT="/etc/mkinitcpio.conf"
    MODULES_LINE="MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)"

    if ! grep -q "nvidia_drm" "$MKINIT"; then
        log "updating mkinitcpio modules"
        sudo sed -i "s/^MODULES=.*/$MODULES_LINE/" "$MKINIT"
        sudo mkinitcpio -P
    else
        log "nvidia modules already present in $MKINIT"
    fi
fi
