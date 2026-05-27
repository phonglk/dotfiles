# Agent Orientation: bin

This package stows utilities into `~/.bin`.

## What It Owns

- `pre-install`, which creates `~/bin`.
- `.bin/backup/*`, including backup exclude rules and the backup script.

## Install Notes

- Installed with `./install.sh bin`.
- Stowed paths land under the user's home directory because this repo uses
  `stow --dotfiles -t ~/`.

## Change Notes

- Treat backup scripts as potentially destructive until inspected.
- Keep backup exclude lists explicit and machine-aware.
