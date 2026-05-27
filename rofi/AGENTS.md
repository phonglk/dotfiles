# Agent Orientation: rofi

This package owns Rofi launcher configuration for Linux.

## What It Owns

- `.config/rofi/baspar.rasi`, the Rofi theme.
- `.local/rofi/config`, the local Rofi config.

## Install Notes

- Installed with `./install.sh rofi`.
- There is no package hook.

## Change Notes

- Keep visual/theme changes small and test with Rofi where possible.
- This package is Linux-specific and should not carry macOS launcher config.
