#!/usr/bin/env bash

PKG="$(basename $1)"
echo "Installing $PKG"

if test -f "./$PKG/pre-install"; then
  echo "Running pre-install script"
  ./$PKG/pre-install
fi

if ! [ -x "$(command -v stow)" ]; then
  echo "stow is not installed" >&2
  exit 1
fi

echo Linking
stow -R --dotfiles -t ~/ --ignore="(pre|post)-install|DS_Store" $PKG

if test -f "./$PKG/post-install"; then
  echo "Running post-install script"
  ./$PKG/post-install
fi

