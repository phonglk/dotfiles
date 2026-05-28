# Cursor Usage SketchyBar Item

Drop-in SketchyBar item for showing Cursor usage as a compact percentage.

The bar item shows a cursor glyph and usage percentage. Click it to toggle a
popup with exact spend, reset time, and account policy details.

## Install

Copy the item and plugin scripts into a SketchyBar config:

```text
~/.config/sketchybar/items/cursor_usage.sh
~/.config/sketchybar/plugins/cursor_usage.sh
~/.config/sketchybar/plugins/cursor_usage_click.sh
```

Then source the item from `sketchybarrc` after your bar defaults are configured:

```sh
. "$HOME/.config/sketchybar/items/cursor_usage.sh"
```

## Optional Config

The item works without config by using the email from Cursor's signed-in
desktop session.

To customize it:

```sh
cp ~/.config/sketchybar/cursor_usage.conf.example \
  ~/.config/sketchybar/cursor_usage.conf
```

Leave `CURSOR_USAGE_EMAIL` empty to auto-detect the signed-in Cursor account.
Set it only if you want the widget to fail closed when Cursor is signed into a
different account.

## Dependencies

- Cursor desktop app signed in.
- `sketchybar`, `jq`, `curl`, and `sqlite3`.
- A Nerd Font that includes the pointer glyph used by the icon segment.

The script reads Cursor's local app token into memory for one refresh and only
sends it to Cursor-owned API endpoints. It never writes raw tokens or raw API
responses to disk.
