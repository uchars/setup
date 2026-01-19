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

log "adding 'splash quiet loglevel=3' to boot entries"
BOOT_ENTRIES_DIR="/boot/loader/entries"
find $BOOT_ENTRIES_DIR -maxdepth 1 -name '*.conf' -type f | while read -r entry; do
    log "checking $entry"
    [ -f "$entry" ] || continue
    if grep -q '^options' "$entry"; then
        if ! grep -q '^options .*splash' "$entry"; then
            sudo sed -i \
                '/^options / s/$/ splash quiet loglevel=3/' \
                "$entry"
            log "appended plymouth lines to options of $entry"
        fi
    fi
done

log "adding image to the spinner plymouth theme"
THEME_NAME="spinner"
THEME_DIR="/usr/share/plymouth/themes/$THEME_NAME"
PLYMOUTH_IMAGE="$ROOT_DIR/wallpapers/foggy_mountain.jpg"
sudo cp "$PLYMOUTH_IMAGE" "$THEME_DIR/background-tile.jpg"
sudo chmod 644 "$THEME_DIR/background-tile.jpg"

sudo plymouth-set-default-theme -R $THEME_NAME

