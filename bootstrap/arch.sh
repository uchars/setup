#!/usr/bin/env bash
set -euo pipefail

log "Arch / CachyOS bootstrap"

is_installed() {
  pacman -Qi "$1" &>/dev/null
}

log "Installing base packages"
sudo pacman -S --noconfirm --needed base-devel git curl pipewire

if ! command_exists yay; then
  log "Installing yay (AUR helper)"
  tmpdir="$(mktemp -d)"
  trap 'rm -rf "$tmpdir"' EXIT

  git clone https://aur.archlinux.org/yay.git "$tmpdir/yay"
  pushd "$tmpdir/yay" >/dev/null
  makepkg -si --noconfirm
  popd >/dev/null
else
  log "yay already installed"
fi

if [[ "${ENABLE_NVIDIA:-false}" == "true" ]]; then
    log "install nvidia stuff"
    sudo pacman -S --noconfirm --needed nvidia-dkms nvidia-settings nvidia-utils
fi

PACMAN_CONF="/etc/pacman.conf"
log "enable multilib for pacman"
if ! grep -q "^\[multilib\]" "$PACMAN_CONF"; then
	echo -e "\n[multilib]\nInclude = /etc/pacman.d/mirrorlist" | sudo tee -a "$PACMAN_CONF"
	log "added multilib section to pacman conf"
else
	if ! grep -q "^\[multilib\]" -A 1 "$PACMAN_CONF" | grep -q "^Include = /etc/pacman.d/mirrorlist"; then
		sudo sed -i "/^\[multilib\]/a Include = /etc/pacman.d/mirrorlist" "$PACMAN_CONF"
		log "added correct line for multilib"
	else
		log "multilib already added correctly"
	fi
fi
sudo pacman -Syy

if [[ -f $ROOT_DIR/packages/arch.txt ]]; then
  log "Installing pacman packages"
  sudo pacman -S --noconfirm --needed $(grep -vE '^\s*#|^\s*$' $ROOT_DIR/packages/arch.txt)
fi

if [[ -f $ROOT_DIR/packages/arch-aur.txt ]]; then
  log "Installing AUR packages"
  yay -S --noconfirm --needed $(grep -vE '^\s*#|^\s*$' $ROOT_DIR/packages/arch-aur.txt)
fi

systemctl --user  enable --now pipewire pipewire-pulse wireplumber
