#!/usr/bin/env bash

set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <package>" >&2
  exit 2
fi

PKG="$1"
if [[ ! "$PKG" =~ ^[[:alnum:]][[:alnum:]_.-]*$ ]]; then
  echo "Invalid package name: $PKG" >&2
  exit 2
fi

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PACKAGE_DIR="$SCRIPT_DIR/$PKG"

if [[ ! -d "$PACKAGE_DIR" ]]; then
  echo "Unknown package: $PKG" >&2
  exit 2
fi

if ! command -v stow >/dev/null 2>&1; then
  echo "stow is not installed" >&2
  exit 1
fi

for hook in pre-install post-install; do
  if [[ -f "$PACKAGE_DIR/$hook" && ! -x "$PACKAGE_DIR/$hook" ]]; then
    echo "$PKG/$hook is not executable" >&2
    exit 1
  fi
done

echo "Installing $PKG"

echo "Checking links"
stow --simulate -R \
  --dotfiles \
  --dir="$SCRIPT_DIR" \
  --target="$HOME" \
  --ignore='(^|/)(pre|post)-install$|(^|/)\.DS_Store$|(^|/)AGENTS\.md$' \
  "$PKG"

if [[ -f "$PACKAGE_DIR/pre-install" ]]; then
  echo "Running pre-install script"
  "$PACKAGE_DIR/pre-install"
fi

echo Linking
stow -R \
  --dotfiles \
  --dir="$SCRIPT_DIR" \
  --target="$HOME" \
  --ignore='(^|/)(pre|post)-install$|(^|/)\.DS_Store$|(^|/)AGENTS\.md$' \
  "$PKG"

if [[ -f "$PACKAGE_DIR/post-install" ]]; then
  echo "Running post-install script"
  "$PACKAGE_DIR/post-install"
fi
