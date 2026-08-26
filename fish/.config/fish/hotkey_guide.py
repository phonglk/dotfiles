#!/usr/bin/env python3

"""Read-only terminal UI for the shared dotfiles shortcut catalog."""

from __future__ import annotations

import argparse
import curses
import locale
import re
import sys
import textwrap
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable, Sequence


TABS = (
    ("All", "all"),
    ("Fish", "fish"),
    ("Built-in", "builtin"),
    ("Kitty", "kitty"),
    ("tmux", "tmux"),
)

SGR_MOUSE_SEQUENCE = re.compile(r"^\[<(\d+);(\d+);(\d+)([Mm])$")
VALID_TAB_IDS = {tab_id for _label, tab_id in TABS if tab_id != "all"}


@dataclass(frozen=True)
class Shortcut:
    status: str
    key: str
    description: str
    tab: str


def load_shortcuts(snapshot_path: Path) -> list[Shortcut]:
    shortcuts: list[Shortcut] = []
    for line_number, line in enumerate(
        snapshot_path.read_text(encoding="utf-8").splitlines(), start=1
    ):
        if not line:
            continue
        fields = line.split("|", 9)
        if len(fields) != 10:
            raise ValueError(f"invalid snapshot row {line_number}")

        (
            status,
            _scope,
            _category,
            _modes,
            key,
            _binding,
            _deps,
            description,
            tab,
            _issues,
        ) = fields
        if tab not in VALID_TAB_IDS:
            raise ValueError(f"invalid tab on snapshot row {line_number}: {tab}")
        shortcuts.append(Shortcut(status, key, description, tab))

    if not shortcuts:
        raise ValueError("shortcut snapshot is empty")
    return shortcuts


class ShortcutGuide:
    TITLE_Y = 0
    TABS_Y = 2
    HEADER_Y = 4
    BODY_Y = 6

    def __init__(self, screen: curses.window, shortcuts: Sequence[Shortcut]) -> None:
        self.screen = screen
        self.shortcuts = shortcuts
        self.active_tab = 0
        self.offset = 0
        self.query = ""
        self.searching = False
        self.tab_bounds: list[tuple[int, int, int]] = []
        self.colors: dict[str, int] = {}
        self._configure_terminal()

    def _configure_terminal(self) -> None:
        self.screen.keypad(True)
        self.screen.timeout(-1)
        try:
            curses.set_escdelay(250)
        except (AttributeError, curses.error):
            pass
        try:
            curses.curs_set(0)
        except curses.error:
            pass

        mouse_events = curses.ALL_MOUSE_EVENTS | getattr(
            curses, "REPORT_MOUSE_POSITION", 0
        )
        try:
            curses.mousemask(mouse_events)
            curses.mouseinterval(0)
        except curses.error:
            pass

        self.colors = {
            "title": curses.A_BOLD,
            "tab": curses.A_NORMAL,
            "active_tab": curses.A_REVERSE | curses.A_BOLD,
            "header": curses.A_BOLD,
            "key": curses.A_BOLD,
            "search": curses.A_BOLD,
        }
        if not curses.has_colors():
            return

        try:
            curses.start_color()
            curses.use_default_colors()
            curses.init_pair(1, curses.COLOR_CYAN, -1)
            curses.init_pair(2, curses.COLOR_BLACK, curses.COLOR_CYAN)
            curses.init_pair(3, curses.COLOR_YELLOW, -1)
            curses.init_pair(4, curses.COLOR_MAGENTA, -1)
            curses.init_pair(5, curses.COLOR_GREEN, -1)
        except curses.error:
            return

        self.colors.update(
            {
                "title": curses.color_pair(4) | curses.A_BOLD,
                "tab": curses.color_pair(1),
                "active_tab": curses.color_pair(2) | curses.A_BOLD,
                "header": curses.color_pair(1) | curses.A_BOLD,
                "key": curses.color_pair(3) | curses.A_BOLD,
                "search": curses.color_pair(5) | curses.A_BOLD,
            }
        )

    def _visible_shortcuts(self) -> list[Shortcut]:
        tab_id = TABS[self.active_tab][1]
        query = self.query.casefold()
        visible = []
        for shortcut in self.shortcuts:
            if tab_id != "all" and shortcut.tab != tab_id:
                continue
            if query and query not in f"{shortcut.key} {shortcut.description}".casefold():
                continue
            visible.append(shortcut)
        return visible

    def _safe_addstr(
        self, y: int, x: int, text: str, width: int, attribute: int = 0
    ) -> None:
        height, screen_width = self.screen.getmaxyx()
        if y < 0 or y >= height or x < 0 or x >= screen_width or width <= 0:
            return
        try:
            self.screen.addnstr(y, x, text, min(width, screen_width - x), attribute)
        except curses.error:
            pass

    def _draw_rule(self, y: int) -> None:
        _height, width = self.screen.getmaxyx()
        self._safe_addstr(y, 1, "─" * max(0, width - 2), max(0, width - 2))

    def _draw_tabs(self, width: int) -> None:
        self.tab_bounds = []
        x = 2
        for index, (label, _tab_id) in enumerate(TABS):
            text = f" {label} "
            if x + len(text) >= width - 1:
                break
            attribute = (
                self.colors["active_tab"]
                if index == self.active_tab
                else self.colors["tab"]
            )
            self._safe_addstr(self.TABS_Y, x, text, len(text), attribute)
            self.tab_bounds.append((x, x + len(text), index))
            x += len(text) + 1

    def _draw_body(self, visible: Sequence[Shortcut], height: int, width: int) -> None:
        body_bottom = height - 2
        body_height = max(0, body_bottom - self.BODY_Y)
        if body_height == 0:
            return

        content_width = max(1, width - 4)
        longest_key = max((len(shortcut.key) for shortcut in visible), default=16)
        key_width = min(max(16, longest_key), min(34, max(16, content_width // 2)))
        description_x = 2 + key_width + 2
        description_width = max(1, width - description_x - 2)

        self._safe_addstr(
            self.HEADER_Y, 2, "Shortcut", key_width, self.colors["header"]
        )
        self._safe_addstr(
            self.HEADER_Y,
            description_x,
            "Description",
            description_width,
            self.colors["header"],
        )

        if not visible:
            self._safe_addstr(
                self.BODY_Y,
                2,
                "No matching shortcuts",
                width - 4,
                curses.A_DIM,
            )
            return

        self.offset = min(self.offset, max(0, len(visible) - 1))

        y = self.BODY_Y
        for shortcut in visible[self.offset :]:
            key_lines = textwrap.wrap(
                shortcut.key,
                key_width,
                break_long_words=True,
                break_on_hyphens=False,
            ) or [""]
            description_lines = textwrap.wrap(
                shortcut.description,
                description_width,
                break_long_words=False,
                break_on_hyphens=False,
            ) or [""]
            row_height = max(len(key_lines), len(description_lines))
            if y + row_height > body_bottom:
                break

            inactive = shortcut.status == "inactive"
            base_attribute = curses.A_DIM if inactive else curses.A_NORMAL
            key_attribute = base_attribute | (
                curses.A_NORMAL if inactive else self.colors["key"]
            )
            for line_index in range(row_height):
                if line_index < len(key_lines):
                    self._safe_addstr(
                        y + line_index,
                        2,
                        key_lines[line_index],
                        key_width,
                        key_attribute,
                    )
                if line_index < len(description_lines):
                    self._safe_addstr(
                        y + line_index,
                        description_x,
                        description_lines[line_index],
                        description_width,
                        base_attribute,
                    )
            y += row_height

    def _draw_footer(self, visible: Sequence[Shortcut], height: int, width: int) -> None:
        if self.searching or self.query:
            footer = f"Search: {self.query}"
            attribute = self.colors["search"]
        else:
            footer = "Click a tab or use 1-5/F1-F5/←→ · ↑↓ scroll · / search · Esc close"
            attribute = curses.A_DIM

        count = f"{len(visible)} shortcuts"
        self._safe_addstr(height - 1, 1, footer, max(0, width - len(count) - 4), attribute)
        self._safe_addstr(
            height - 1,
            max(1, width - len(count) - 1),
            count,
            len(count),
            curses.A_DIM,
        )

    def draw(self) -> None:
        self.screen.erase()
        height, width = self.screen.getmaxyx()
        if height < 10 or width < 44:
            message = "Resize the terminal to at least 44×10"
            self._safe_addstr(
                max(0, height // 2),
                max(0, (width - len(message)) // 2),
                message,
                width,
                curses.A_BOLD,
            )
            self.screen.refresh()
            return

        visible = self._visible_shortcuts()
        self._safe_addstr(
            self.TITLE_Y, 2, "Shortcut Guide", width - 4, self.colors["title"]
        )
        self._draw_tabs(width)
        self._draw_rule(3)
        self._draw_rule(5)
        self._draw_body(visible, height, width)
        self._draw_footer(visible, height, width)
        if self.searching:
            cursor_x = min(width - 2, len("Search: ") + len(self.query) + 1)
            try:
                self.screen.move(height - 1, cursor_x)
            except curses.error:
                pass
        self.screen.refresh()

    def _switch_tab(self, index: int) -> None:
        self.active_tab = index % len(TABS)
        self.offset = 0

    def _activate_tab_at(self, x: int, y: int) -> bool:
        if y != self.TABS_Y:
            return False
        for start, end, index in self.tab_bounds:
            if start <= x < end:
                self._switch_tab(index)
                return True
        return False

    def _handle_mouse(self) -> None:
        try:
            _mouse_id, x, y, _z, state = curses.getmouse()
        except curses.error:
            return

        click_events = (
            getattr(curses, "BUTTON1_CLICKED", 0)
            | getattr(curses, "BUTTON1_RELEASED", 0)
            | getattr(curses, "BUTTON1_PRESSED", 0)
        )
        if y == self.TABS_Y and state & click_events:
            if self._activate_tab_at(x, y):
                return

        if state & getattr(curses, "BUTTON4_PRESSED", 0):
            self.offset = max(0, self.offset - 2)
        elif state & getattr(curses, "BUTTON5_PRESSED", 0):
            self.offset += 2

    def _handle_raw_escape_sequence(self) -> bool:
        """Handle SGR mouse input when an older curses exposes the raw bytes."""

        sequence = ""
        self.screen.timeout(100)
        try:
            while len(sequence) < 64:
                key = self.screen.get_wch()
                if key == curses.KEY_MOUSE:
                    self._handle_mouse()
                    return True
                if not isinstance(key, str):
                    return True
                sequence += key
                if key in ("M", "m"):
                    break
        except curses.error:
            pass
        finally:
            self.screen.timeout(-1)

        if not sequence:
            return False

        match = SGR_MOUSE_SEQUENCE.match(sequence)
        if not match:
            return True

        button, x, y, _event = match.groups()
        button_number = int(button)
        x_coordinate = int(x) - 1
        y_coordinate = int(y) - 1
        if button_number == 0:
            self._activate_tab_at(x_coordinate, y_coordinate)
        elif button_number == 64:
            self.offset = max(0, self.offset - 2)
        elif button_number == 65:
            self.offset += 2
        return True

    def _handle_search_key(self, key: object) -> bool:
        if not self.searching:
            return False
        if key in ("\n", "\r"):
            self.searching = False
            try:
                curses.curs_set(0)
            except curses.error:
                pass
            return True
        if key in (curses.KEY_BACKSPACE, "\b", "\x7f"):
            self.query = self.query[:-1]
            self.offset = 0
            return True
        if key == "\x15":
            self.query = ""
            self.offset = 0
            return True
        if isinstance(key, str) and key.isprintable():
            self.query += key
            self.offset = 0
            return True
        return True

    def run(self) -> None:
        while True:
            self.draw()
            try:
                key = self.screen.get_wch()
            except curses.error:
                continue

            if key == "\x1b":
                if self._handle_raw_escape_sequence():
                    continue
                return
            if self._handle_search_key(key):
                continue
            if key in ("q", "Q"):
                return
            if key == "/":
                self.searching = True
                try:
                    curses.curs_set(1)
                except curses.error:
                    pass
                continue
            if key == curses.KEY_MOUSE:
                self._handle_mouse()
                continue
            if key in (curses.KEY_RIGHT, "\t"):
                self._switch_tab(self.active_tab + 1)
                continue
            if key in (curses.KEY_LEFT, curses.KEY_BTAB):
                self._switch_tab(self.active_tab - 1)
                continue
            if key in (curses.KEY_DOWN, "j"):
                self.offset += 1
                continue
            if key in (curses.KEY_UP, "k"):
                self.offset = max(0, self.offset - 1)
                continue
            if key in (curses.KEY_NPAGE, " "):
                height, _width = self.screen.getmaxyx()
                self.offset += max(1, (height - self.BODY_Y - 2) // 2)
                continue
            if key == curses.KEY_PPAGE:
                height, _width = self.screen.getmaxyx()
                self.offset = max(
                    0, self.offset - max(1, (height - self.BODY_Y - 2) // 2)
                )
                continue
            if key == curses.KEY_HOME:
                self.offset = 0
                continue
            if key == curses.KEY_END:
                self.offset = max(0, len(self._visible_shortcuts()) - 1)
                continue
            if isinstance(key, str) and key in "12345":
                self._switch_tab(int(key) - 1)
                continue
            function_keys = {
                curses.KEY_F1: 0,
                curses.KEY_F2: 1,
                curses.KEY_F3: 2,
                curses.KEY_F4: 3,
                curses.KEY_F5: 4,
            }
            if key in function_keys:
                self._switch_tab(function_keys[key])


def print_check(shortcuts: Iterable[Shortcut]) -> None:
    shortcut_list = list(shortcuts)
    counts = [f"all={len(shortcut_list)}"]
    for label, tab_id in TABS[1:]:
        count = sum(shortcut.tab == tab_id for shortcut in shortcut_list)
        counts.append(f"{label.lower()}={count}")
    print(" ".join(counts))


def parse_args(argv: Sequence[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("snapshot", type=Path)
    parser.add_argument("--check", action="store_true")
    return parser.parse_args(argv)


def main(argv: Sequence[str] | None = None) -> int:
    try:
        locale.setlocale(locale.LC_ALL, "")
    except locale.Error:
        pass
    args = parse_args(sys.argv[1:] if argv is None else argv)
    try:
        shortcuts = load_shortcuts(args.snapshot)
    except (OSError, UnicodeError, ValueError) as error:
        print(f"hotkey-guide: {error}", file=sys.stderr)
        return 2

    if args.check:
        print_check(shortcuts)
        return 0
    if not sys.stdin.isatty() or not sys.stdout.isatty():
        for shortcut in shortcuts:
            print(f"{shortcut.key}\t{shortcut.description}")
        return 0

    try:
        curses.wrapper(lambda screen: ShortcutGuide(screen, shortcuts).run())
    except KeyboardInterrupt:
        pass
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
