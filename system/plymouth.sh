#!/usr/bin/env bash
set -euo pipefail

if ! command_exists plymouth; then
	log "Plymouth not installed"
	exit 0;
fi

if ! grep -q 'plymouth' /etc/mkinitcpio.conf; then
	log "adding plymouth to mkinitcpio"
	if [[ ! -f "$HOME/.local/mkinitcpio.bak" ]]; then
		log "creating backup of initial mkinitcpio"
		cp /etc/mkinitcpio.conf $HOME/.local/mkinitcpio.bak
	else
		log "backup of initial mkinitcpio is already present in $HONE/.local/mkinitcpio.bak"
	fi
	sudo sed -i 's/^HOOKS=(\(.*\))$/HOOKS=(\1 plymouth)/' /etc/mkinitcpio.conf
	sudo mkinitcpio -P
else
	log "plymouth is already present in mkinitcpio"
fi

log "adding image to the spinner plymouth theme"
THEME_NAME="spinner"
THEME_DIR="/usr/share/plymouth/themes/$THEME_NAME"
PLYMOUTH_IMAGE="$ROOT_DIR/wallpapers/foggy_mountain.jpg"
sudo cp "$PLYMOUTH_IMAGE" "$THEME_DIR/background-tile.jpg"
sudo chmod 644 "$THEME_DIR/background-tile.jpg"

sudo plymouth-set-default-theme -R $THEME_NAME

