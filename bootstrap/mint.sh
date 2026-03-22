#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$ROOT_DIR/scripts/helpers.sh"

install_apt_if_available() {
	local pkg="$1"
	if apt-cache show "$pkg" >/dev/null 2>&1; then
		log "Installing apt package: $pkg"
		sudo apt-get install -y "$pkg"
		return 0
	else
		log "Package $pkg not found in apt repos"
		return 1
	fi
}

# flatpak installs delegated to scripts/helpers.sh -> install_flatpaks()

bootstrap_mint() {
	PKGS_APT=(unzip fzf ripgrep vlc feh plymouth vim xclip pcscd unrar ninja-build cmake docker.io wine inkscape blender tmux picom dmenu rofi)
	DEV_PKGS=(libx11-dev libxft-dev libxrender-dev libfido2-dev libxinerama-dev libx11-xcb-dev libxcb-res0-dev libxcb-util-dev python3.12-venv libpipewire-0.3-dev pkg-config clang libdbus-1-dev)

	log "Updating apt repositories"
	sudo apt-get update
	sudo apt-get upgrade -y

	sudo apt-get install -y "${PKGS_APT[@]}" "${DEV_PKGS[@]}" || log "some packages failed to install"

	if command_exists docker; then
		sudo systemctl enable --now docker || true
		sudo usermod -aG docker "$USER" || true
	fi

	sh -c "$(curl -fsLS get.chezmoi.io)" -- -b $HOME/.local/bin

	if ! command_exists otd; then
		wget https://github.com/OpenTabletDriver/OpenTabletDriver/releases/latest/download/opentabletdriver-0.6.6.2-1-x64.deb -O $HOME/Downloads/opentablet.deb && sudo apt install -y $HOME/Downloads/opentablet.deb
		systemctl --user enable opentabletdriver.service --now
	fi
	sudo apt autoremove -y

	log "Mint bootstrap completed"
}

bootstrap_mint "$@"

