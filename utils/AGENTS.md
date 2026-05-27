# Agent Orientation: utils

This package contains miscellaneous bootstrap scripts that are not stowed as a
main shell package.

## What It Owns

- `install_fish.sh`, currently a placeholder shell script.

## Install Notes

- This directory is not a typical Stow package with dotfiles today.
- Inspect intended usage before adding more utility behavior here.

## Change Notes

- Prefer putting user-facing CLI helpers in `bash/bin` unless the helper is
  specifically a bootstrap utility.
