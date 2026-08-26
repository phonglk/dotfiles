function __fish_hotkeys_records
    set -l catalog "$__fish_config_dir/hotkeys.psv"

    if not test -r "$catalog"
        printf 'fish_hotkeys: cannot read %s\n' "$catalog" >&2
        return 1
    end

    while read -l line
        string match -qr '^\s*(#|$)' -- "$line"; and continue

        set -l fields (string split -m 7 '|' -- "$line")
        if test (count $fields) -ne 8
            printf 'fish_hotkeys: invalid catalog row: %s\n' "$line" >&2
            continue
        end

        set -l scope $fields[1]
        set -l category $fields[2]
        set -l modes $fields[3]
        set -l display_key $fields[4]
        set -l binding_keys $fields[5]
        set -l dependencies $fields[6]
        set -l description $fields[7]
        set -l tab $fields[8]
        set -l issues

        if test "$dependencies" != -
            set -l missing
            for dependency in (string split ',' -- "$dependencies")
                type -q "$dependency"; or set -a missing "$dependency"
            end
            if test (count $missing) -gt 0
                set -a issues "missing: "(string join ', ' -- $missing)
            end
        end

        set -l row_status reference
        if test "$scope" = fish; and test "$binding_keys" != -
            set row_status active
            set -l unbound
            for mode in (string split ',' -- "$modes")
                for binding_key in (string split ',' -- "$binding_keys")
                    bind -M "$mode" "$binding_key" >/dev/null 2>&1
                    or set -a unbound "$mode/$binding_key"
                end
            end
            if test (count $unbound) -gt 0
                set -a issues "unbound: "(string join ', ' -- $unbound)
            end
        end

        if test (count $issues) -gt 0
            set row_status inactive
        end

        printf '%s|%s|%s|%s|%s|%s|%s|%s|%s|%s\n' \
            "$row_status" "$scope" "$category" "$modes" "$display_key" \
            "$binding_keys" "$dependencies" "$description" "$tab" \
            (string join '; ' -- $issues)
    end <"$catalog"
end

function __fish_hotkeys_record_matches_tab --argument-names selected_tab record_tab
    test "$selected_tab" = all; or test "$selected_tab" = "$record_tab"
end

function __fish_hotkeys_render_record --argument-names record
    set -l fields (string split -m 9 '|' -- "$record")
    test (count $fields) -eq 10; or return 1

    printf '%s\t%s\n' "$fields[5]" "$fields[8]"
end

function __fish_hotkeys_render
    set -l tab all
    if test (count $argv) -gt 0
        set tab "$argv[1]"
    end

    for record in (__fish_hotkeys_records)
        set -l fields (string split -m 9 '|' -- "$record")
        test (count $fields) -eq 10; or continue
        __fish_hotkeys_record_matches_tab "$tab" "$fields[9]"; or continue
        __fish_hotkeys_render_record "$record"
    end
end

function __fish_hotkeys_open_tui
    set -l guide "$__fish_config_dir/hotkey_guide.py"
    if not test -r "$guide"
        printf 'fish_hotkeys: cannot read %s\n' "$guide" >&2
        return 1
    end

    set -l python
    for candidate in python3 python
        set -l candidate_path (command -s "$candidate" 2>/dev/null)
        test -n "$candidate_path"; or continue
        "$candidate_path" -c 'import curses, sys; raise SystemExit(sys.version_info < (3, 8))' >/dev/null 2>&1; or continue
        set python "$candidate_path"
        break
    end

    if test -z "$python"
        printf 'fish_hotkeys: Python 3 with curses is unavailable; showing the plain guide\n' >&2
        return 127
    end

    if not type -q mktemp
        printf 'fish_hotkeys: mktemp is unavailable; showing the plain guide\n' >&2
        return 127
    end

    set -l temp_root /tmp
    if set -q TMPDIR; and test -d "$TMPDIR"
        set temp_root (string replace -r '/$' '' -- "$TMPDIR")
    end

    set -l snapshot (command mktemp "$temp_root/fish-hotkeys.XXXXXX")
    if test $status -ne 0; or test -z "$snapshot"
        printf 'fish_hotkeys: could not create shortcut snapshot\n' >&2
        return 1
    end

    __fish_hotkeys_records >"$snapshot"
    set -l record_status $status
    if test $record_status -ne 0
        command rm -f -- "$snapshot"
        return $record_status
    end

    "$python" "$guide" "$snapshot"
    set -l guide_status $status
    command rm -f -- "$snapshot"
    return $guide_status
end

function __fish_hotkeys_print_tip
    set -l candidates
    for record in (__fish_hotkeys_records)
        set -l fields (string split -m 9 '|' -- "$record")
        test (count $fields) -eq 10; or continue
        test "$fields[1]" = inactive; and continue
        set -a candidates "$record"
    end

    set -l candidate_count (count $candidates)
    test $candidate_count -gt 0; or return 1

    set -l candidate_index (random 1 $candidate_count)
    set -l fields (string split -m 9 '|' -- "$candidates[$candidate_index]")

    set -l label_color
    set -l key_color
    set -l reset_color
    if status is-interactive; and test -t 1
        set label_color (set_color --bold brcyan)
        set key_color (set_color --bold bryellow)
        set reset_color (set_color normal)
    end

    printf '%sTip%s: %s%s%s — %s · Ctrl-G opens the guide\n' \
        "$label_color" "$reset_color" "$key_color" "$fields[5]" \
        "$reset_color" "$fields[8]"
end

function __fish_hotkeys_print_startup_tip
    set -q DOTFILES_HOTKEY_TIPS_DISABLED; and return
    set -q __fish_hotkeys_startup_tip_shown; and return

    set -g __fish_hotkeys_startup_tip_shown 1
    __fish_hotkeys_print_tip
end

function __fish_hotkeys_install_bindings
    for mode in default insert visual
        bind -M "$mode" >/dev/null 2>&1; or continue
        bind -M "$mode" ctrl-g 'fish_hotkeys; commandline -f repaint'
    end
end

function fish_hotkeys --description 'Show a searchable guide to shell and terminal shortcuts'
    set -l action show
    if test (count $argv) -gt 0
        set action "$argv[1]"
    end

    switch "$action"
        case show
            __fish_hotkeys_open_tui
            set -l guide_status $status
            if test $guide_status -eq 127
                if status is-interactive; and type -q less
                    __fish_hotkeys_render | command less -R
                else
                    __fish_hotkeys_render
                end
            else
                return $guide_status
            end

        case --print
            set -l tab all
            if test (count $argv) -gt 1
                set tab "$argv[2]"
            end
            contains -- "$tab" all fish builtin kitty tmux
            or begin
                printf 'fish_hotkeys: unknown tab: %s\n' "$tab" >&2
                return 2
            end
            __fish_hotkeys_render "$tab"

        case --tip
            __fish_hotkeys_print_tip

        case --startup-tip --daily-tip
            __fish_hotkeys_print_startup_tip

        case --install-bindings
            __fish_hotkeys_install_bindings

        case --standalone
            type -q fish_user_key_bindings; and fish_user_key_bindings >/dev/null 2>&1
            __fish_hotkeys_install_bindings
            fish_hotkeys

        case -h --help
            printf '%s\n' \
                'Usage: fish_hotkeys [--print [all|fish|builtin|kitty|tmux]|--tip|--startup-tip|--install-bindings|--standalone]' \
                'With no option, opens the read-only clickable and searchable tabbed guide.'

        case '*'
            printf 'fish_hotkeys: unknown option: %s\n' "$action" >&2
            return 2
    end
end
