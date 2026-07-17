#!/usr/bin/env bash
set -euo pipefail

TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT


install_git_if_missing() {
	if command -v git >/dev/null 2>&1; then
		echo "==> git already installed"
		return 0
	fi
	sudo dnf install -y git
}

install_git_if_missing

echo "==> Cloning setup repo..."
git clone --depth 1 https://github.com/uchars/setup.git "$TMPDIR/setup"

echo "==> Running installer..."
/bin/bash "$TMPDIR/setup/install.sh" "$@"

