#!/usr/bin/env bash
set -euo pipefail

TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT

detect_distro() {
	. /etc/os-release
	local id_lc="${ID,,}"
	local like_lc="${ID_LIKE,,}"
	if [[ "$id_lc" == "arch" || "$like_lc" =~ arch ]]; then
		echo arch
	elif [[ "$id_lc" == "fedora" || "$like_lc" =~ fedora ]]; then
		echo fedora
	elif [[ "$id_lc" == "linuxmint" || "$id_lc" == "mint" || "$like_lc" =~ (debian|ubuntu) ]]; then
		echo mint
	else
		echo unknown
	fi
}

DISTRO="$(detect_distro)"
echo "==> Detected distro: $DISTRO"

install_git_if_missing() {
	if command -v git >/dev/null 2>&1; then
		echo "==> git already installed"
		return 0
	fi
	echo "==> Installing git"
	case "$DISTRO" in
		arch)
			sudo pacman -S --noconfirm --needed git
			;;
		fedora)
			sudo dnf install -y git
			;;
		mint)
			sudo apt-get update
			sudo apt-get install -y git
			;;
		*)
			echo "Unsupported distro for automated git install. Please install git and re-run."
			exit 1
			;;
	esac
}

install_git_if_missing

echo "==> Cloning setup repo..."
git clone --depth 1 https://github.com/uchars/setup.git "$TMPDIR/setup"

echo "==> Running installer..."
/bin/bash "$TMPDIR/setup/install.sh" "$@"

