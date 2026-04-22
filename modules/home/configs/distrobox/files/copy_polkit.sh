#!/usr/bin/env bash
set -euo pipefail

TMP_POLKIT_DIR="$HOME/kde/usr/share/polkit-1/actions/tmp"
mkdir -p "$TMP_POLKIT_DIR"

for f in "$HOME/kde/usr/share/polkit-1/actions/"*.policy; do
    base=$(basename "$f" .policy)
    cp "$f" "$TMP_POLKIT_DIR/99-$base-custom.policy"
done

sudo cp -r "$TMP_POLKIT_DIR/"* /usr/share/polkit-1/actions/
rm -rf "$TMP_POLKIT_DIR"
