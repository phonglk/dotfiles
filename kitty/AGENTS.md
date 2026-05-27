# Agent Orientation: kitty

This package owns Kitty terminal configuration.

## What It Owns

- `.config/kitty/kitty.conf`, including font, cursor, scrollback, and terminal
  behavior settings.

## Install Notes

- Installed with `./install.sh kitty`.
- There is no package hook.

## Change Notes

- The config uses Nerd Font symbols and assumes the named font is installed.
- Avoid broad rewrites of the generated/default Kitty comments unless requested.
