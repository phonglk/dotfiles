# Agent Orientation: sketchybar

This package owns the macOS SketchyBar configuration.

## What It Owns

- `.config/sketchybar/sketchybarrc`, the main bar layout and item definitions.
- `.config/sketchybar/plugins/*`, scripts for bar items.
- Buildkite/PR tracking config examples and the current local PR list.
- `pre-install`, which checks Homebrew, installs SketchyBar if missing, starts
  the service, and creates `~/.config/sketchybar`.

## PR/CI Widget

- The `bk_status` item is configured in `sketchybarrc` and is associated with
  display 2.
- `plugins/buildkite.sh` reads `~/.config/sketchybar/buildkite-prs.conf`, calls
  `gh pr view --json statusCheckRollup`, updates up to three popup rows, caches
  PR URLs under `~/tmp/sketchybar-cache`, and sends macOS notifications when
  checks finish.
- `plugins/buildkite_click.sh` opens cached PR URLs or shows an AppleScript
  chooser.
- `bash/bin/bk-track` is the CLI used to add, remove, list, debug, and inspect
  tracked PRs.

## Install Notes

- Installed with `./install.sh sketchybar`.
- Do not run the hook unless the user wants Homebrew/service changes.

## Change Notes

- Keep local `.env` and machine-specific PR lists out of commits unless the user
  explicitly asks otherwise.
- Run `sh -n` or `bash -n` on touched shell scripts.
- Be careful with display-specific settings such as `associated_display=2`.
