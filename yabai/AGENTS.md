# Agent Orientation: yabai

This package owns macOS yabai tiling-window-manager configuration and limelight
border styling.

## What It Owns

- `.yabairc`, including scripting-addition loading, BSP layout, gaps, opacity,
  mouse controls, space rules, app rules, Ubersicht refresh signals, and
  limelight startup.
- `.limelightrc`, active-window border settings.
- `pre-install`, which checks Homebrew and installs yabai if missing.

## Install Notes

- Installed with `./install.sh yabai`.
- Running `.yabairc` may invoke `sudo yabai --load-sa`, send AppleScript events,
  kill/restart limelight, and change live window-manager state.

## Change Notes

- Coordinate hotkey expectations with the `skhd` package.
- Be careful with `sudo`, accessibility permissions, and display/space-specific
  behavior.
- Use `sh -n` for syntax checks on edited shell config.
