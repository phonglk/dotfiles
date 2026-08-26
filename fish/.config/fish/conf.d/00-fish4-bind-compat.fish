function __dotfiles_repair_fish4_bindings
    set -l helper "$HOME/.config/fish/functions/_phonglk_auto_complete_help.fish"
    set -l invalid_pattern '^[[:space:]]*bind --erase --preset( -M (insert|visual))? \\\\cx fish_clipboard_copy$'

    if not test -f "$helper"; or not command grep -Eq "$invalid_pattern" "$helper"
        return
    end

    if not env LC_ALL=C sed -E -i.bak \
        '/^[[:space:]]*bind --erase --preset( -M (insert|visual))? \\\\cx fish_clipboard_copy$/s/ fish_clipboard_copy$//' \
        "$helper"
        test ! -f "$helper.bak"; or command mv -f -- "$helper.bak" "$helper"
        echo "Failed to repair invalid Ctrl-X erase bindings in $helper" >&2
        return 1
    end

    if command grep -Eq "$invalid_pattern" "$helper"
        command mv -f -- "$helper.bak" "$helper"
        echo "Failed to verify repaired Ctrl-X erase bindings in $helper" >&2
        return 1
    end

    command rm -f -- "$helper.bak"
end

__dotfiles_repair_fish4_bindings
functions --erase __dotfiles_repair_fish4_bindings
