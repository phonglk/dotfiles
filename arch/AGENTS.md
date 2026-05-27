# Agent Orientation: arch

This package contains Arch/Linux desktop bootstrap files.

## What It Owns

- `.config/autostart/*.desktop` entries for desktop session startup.
- `.config/xkb/keycodes/phong` for keyboard customization.
- `pre-install`, which only ensures `~/.config/autostart` exists.

## Install Notes

- Installed with `./install.sh arch`.
- The hook is low risk, but the stowed files affect desktop autostart behavior.

## Change Notes

- Keep this package Linux-specific.
- Do not add macOS bootstrap here; use the macOS packages such as `yabai`,
  `skhd`, or `sketchybar`.
