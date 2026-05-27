# Agent Orientation: skhd

This package owns macOS hotkeys for yabai and shell helpers.

## What It Owns

- `.skhdrc`, including vim-style focus/swap/warp bindings, space movement,
  fullscreen/float toggles, display focus, and workspace helper commands.
- `pre-install`, which checks Homebrew and installs `skhd` if missing.

## Install Notes

- Installed with `./install.sh skhd`.
- The hook may run Homebrew. Do not run it unless the user wants bootstrap work.

## Change Notes

- Hotkeys call `yabai`, `fish`, and `jq`; keep those dependencies in mind.
- Coordinate changes with the `yabai` package because most bindings control
  yabai state.
