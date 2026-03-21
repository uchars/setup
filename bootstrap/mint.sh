#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$ROOT_DIR/scripts/helpers.sh"

ensure_sudo() {
	sudo -v || { log "sudo is required"; exit 1; }
}

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
	ensure_sudo

	PKGS_APT=(unzip fzf ripgrep vlc feh plymouth vim xclip pcscd unrar ninja-build cmake docker.io wine inkscape blender)
	DEV_PKGS=(libx11-dev libxft-dev libxrender-dev libfido2-dev)

	declare -A FLATPAK_MAP
	FLATPAK_MAP[bitwarden]=com.bitwarden.desktop
	FLATPAK_MAP[discord]=com.discordapp.Discord
	FLATPAK_MAP[steam]=com.valvesoftware.Steam
	FLATPAK_MAP[bottles]=com.usebottles.bottles
	FLATPAK_MAP[opentoonz]=org.opentoonz.OpenToonz

	log "Updating apt repositories"
	sudo apt-get update

	for p in "${PKGS_APT[@]}"; do
		install_apt_if_available "$p" || true
	done
	for p in "${DEV_PKGS[@]}"; do
		install_apt_if_available "$p" || true
	done

	if command -v docker >/dev/null 2>&1; then
		sudo systemctl enable --now docker || true
		sudo usermod -aG docker "$USER" || true
	fi

	FLATPAKS=("${FLATPAK_MAP[bitwarden]}" "${FLATPAK_MAP[discord]}" "${FLATPAK_MAP[steam]}" "${FLATPAK_MAP[bottles]}" "${FLATPAK_MAP[opentoonz]}")
	install_flatpaks "${FLATPAKS[@]}" || log "Some flatpak installs failed or were skipped"

	if ! command -v fvm >/dev/null 2>&1; then
		if command -v dart >/dev/null 2>&1; then
			log "Installing fvm via 'dart pub global activate fvm'"
			dart pub global activate fvm || log "dart pub activate fvm failed"
		else
			log "Skipping fvm install (dart not available)"
		fi
	fi

	build_krita_from_source() {
		log "Building Krita from source"
		sudo apt-get install -y git build-essential cmake ninja-build pkg-config extra-cmake-modules qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools kio-dev libkf5config-dev gir1.2-kde4-4gir || true

		TMPDIR="${HOME}/.local/src/krita-build"
		mkdir -p "$TMPDIR"
		cd "$TMPDIR"

		if [ -d krita ]; then
			cd krita && git fetch --tags
		else
			git clone https://invent.kde.org/graphics/krita.git
			cd krita
		fi

		LATEST_TAG=$(git tag -l --sort=-v:refname "v*" | head -n1)
		if [ -z "$LATEST_TAG" ]; then
			LATEST_TAG=$(git describe --tags --abbrev=0 || true)
		fi
		if [ -n "$LATEST_TAG" ]; then
			log "Checking out tag: $LATEST_TAG"
			git checkout "$LATEST_TAG" || git checkout master
		else
			log "No tags found, using default branch"
		fi

		mkdir -p build && cd build
		cmake -G Ninja .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local
		ninja -j$(nproc) || { log "Krita build failed"; return 1; }
		sudo ninja install || log "Krita install failed (need sudo)"
	}

	build_krita_from_source || log "Krita build encountered issues"

	build_opentoonz_from_source() {
		log "Building OpenToonz from source (master)"
		sudo apt-get install -y git build-essential cmake ninja-build qtbase5-dev libjpeg-dev libpng-dev libtiff-dev libopenexr-dev libglu1-mesa-dev libglew-dev libxrandr-dev libxi-dev libxcursor-dev libxrender-dev libfreetype6-dev libx11-dev || true

		TMPDIR="${HOME}/.local/src/opentoonz-build"
		mkdir -p "$TMPDIR"
		cd "$TMPDIR"

		if [ -d opentoonz ]; then
			cd opentoonz && git fetch
		else
			git clone https://github.com/opentoonz/opentoonz.git
			cd opentoonz
		fi
		git checkout master || true
		mkdir -p build && cd build
		cmake -G Ninja .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local
		ninja -j$(nproc) || { log "OpenToonz build failed"; return 1; }
		sudo ninja install || log "OpenToonz install failed (need sudo)"
	}

	build_opentoonz_from_source || log "OpenToonz build encountered issues"

	log "Mint bootstrap completed"
}

bootstrap_mint "$@"

