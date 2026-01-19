#!/usr/bin/env bash
set -euo pipefail

TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT

echo "==> Cloning setup repo..."
git clone --depth 1 https://github.com/uchars/setup.git "$TMPDIR/setup"

echo "==> Running installer..."
/bin/bash "$TMPDIR/setup/install.sh"

