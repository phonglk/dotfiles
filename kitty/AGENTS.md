# Agent Orientation: kitty

This package owns Kitty terminal configuration.

## What It Owns

- `.config/kitty/kitty.conf`, including font, cursor, scrollback, and terminal
  behavior settings.
- `.config/kitty/bin/fish`, which resolves the Fish executable across macOS and
  Arch Linux without relying on Kitty's inherited `SHELL` environment value.

## Install Notes

- Installed with `./install.sh kitty`.
- There is no package hook.
- Install the `fish` package first so the launcher can find Fish.

## Change Notes

- The config uses Nerd Font symbols and assumes the named font is installed.
- Kitty launches Fish explicitly as a login, interactive shell. Keep the
  wrapper's standard platform paths portable between macOS and Arch Linux.
- Avoid broad rewrites of the generated/default Kitty comments unless requested.
