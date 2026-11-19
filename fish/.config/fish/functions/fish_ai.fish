function __fish_ai_input_back
    set -g __fish_ai_back 1
    set -g __fish_ai_read_draft (commandline --current-buffer | string collect --allow-empty)
    commandline -f cancel-commandline
end

function __fish_ai_input_cancel
    set -g __fish_ai_cancel 1
    commandline -f cancel-commandline
end

function __fish_ai_panel --argument-names title tone
    set -l columns 80
    if string match -qr '^[1-9][0-9]*$' -- "$COLUMNS"
        set columns "$COLUMNS"
    end
    printf '\n'
    printf '%s\0' $argv[3..-1] | command python3 "$__fish_config_dir/ai_commands.py" panel \
        --title "$title" --tone "$tone" --columns "$columns"
end

function __fish_ai_read_prompt --argument-names mode
    if test "$__fish_ai_ui_color" = 1
        if test "$mode" = refine
            set_color --bold bryellow
        else
            set_color --bold brcyan
        end
    end
    if test "$mode" = refine
        printf '[AI · REFINE] REFINE > '
    else
        printf '[AI] PROMPT > '
    end
    if test "$__fish_ai_ui_color" = 1
        set_color normal
    end
end

function __fish_ai_install_bindings
    # The ordinary reader keeps its existing Enter, Tide, and vi bindings.
    for mode in default insert visual
        bind -M "$mode" ctrl-o fish_ai
    end

    # Plain-text editing in the nested AI reader. Nothing entered here is shell code.
    bind -M fish_ai '' self-insert
    bind -M fish_ai enter execute
    bind -M fish_ai ctrl-j execute
    bind -M fish_ai ctrl-o __fish_ai_input_back
    bind -M fish_ai escape __fish_ai_input_back
    bind -M fish_ai ctrl-c __fish_ai_input_cancel
    bind -M fish_ai ctrl-d delete-or-exit
    bind -M fish_ai backspace backward-delete-char
    bind -M fish_ai ctrl-h backward-delete-char
    bind -M fish_ai delete delete-char
    bind -M fish_ai left backward-char
    bind -M fish_ai right forward-char
    bind -M fish_ai ctrl-b backward-char
    bind -M fish_ai ctrl-f forward-char
    bind -M fish_ai home beginning-of-line
    bind -M fish_ai end end-of-line
    bind -M fish_ai ctrl-a beginning-of-line
    bind -M fish_ai ctrl-e end-of-line
    bind -M fish_ai ctrl-w backward-kill-word
    bind -M fish_ai ctrl-u backward-kill-line
    bind -M fish_ai ctrl-k kill-line
    bind -M fish_ai ctrl-y yank
    bind -M fish_ai ctrl-l clear-screen
end

function fish_ai --description 'Generate and refine editable Fish commands with Codex'
    switch "$argv[1]"
        case --install-bindings
            __fish_ai_install_bindings
            return
        case --back-input
            __fish_ai_input_back
            return
        case --cancel-input
            __fish_ai_input_cancel
            return
        case -h --help
            printf '%s\n' \
                'Ctrl-O: enter AI mode. Enter: generate commands and open the picker.' \
                'In the picker, Enter inserts a command; Ctrl-O opens follow-ups for that option.' \
                'Type your change or choose a numbered follow-up, then Enter updates the options.' \
                'Esc backs out one step. Ctrl-C exits AI mode and restores your shell draft.' \
                'Uses the existing Codex CLI login. Suggested commands are never executed.'
            return
    end

    if set -q __fish_ai_active
        __fish_ai_input_back
        return
    end
    status is-interactive; or begin
        printf 'fish_ai: use Ctrl-O in an interactive Fish terminal\n' >&2
        return 1
    end
    for dependency in python3 fzf
        if not command -q "$dependency"
            printf 'fish_ai: %s is required\n' "$dependency" >&2
            return 127
        end
    end
    set -l helper "$__fish_config_dir/ai_commands.py"
    if not test -r "$helper"
        printf 'fish_ai: missing %s; run setup install fish\n' "$helper" >&2
        return 1
    end
    set -l python (command -s python3)
    # Keep every byte of a multiline shell draft, including trailing newlines.
    set -l original (commandline --current-buffer | "$python" -c 'import sys; b=sys.stdin.buffer.read(); sys.stdout.buffer.write((b[:-1] if b.endswith(b"\n") else b)+b"\0")' | string split0)
    set -l original_cursor (commandline --cursor)
    set -l original_mode "$fish_bind_mode"
    test -n "$original_mode"; or set original_mode default
    set -l temp_root /tmp
    if set -q TMPDIR; and test -d "$TMPDIR"
        set temp_root (string replace -r '/$' '' -- "$TMPDIR")
    end
    set -l session (command mktemp -d "$temp_root/fish-ai.XXXXXX")
    if test $status -ne 0; or test -z "$session"
        printf 'fish_ai: could not create a private session directory\n' >&2
        return 1
    end

    __fish_ai_install_bindings
    set -g __fish_ai_active 1
    set -g __fish_ai_ui_color 0
    if test -t 1; and test "$TERM" != dumb; and test -z "$NO_COLOR"
        set -g __fish_ai_ui_color 1
    end
    set -l fish_autosuggestion_enabled 0
    set -l result "$original"
    set -l result_cursor "$original_cursor"
    set -l ai_mode prompt
    set -l draft ''
    set -l base_label ''
    set -l base_command ''
    set -l base_explanation ''
    set -l follow_ups
    set -l original_request ''
    set -l cached 0
    set -l generated_mode prompt
    set -l generated_draft ''
    set -l inserted 0
    printf '\n'

    while true
        set -l request ''
        if test "$cached" -eq 0
            set -g __fish_ai_back 0
            set -g __fish_ai_cancel 0
            set -e __fish_ai_read_draft
            if test "$ai_mode" = refine
                __fish_ai_panel 'SELECTED COMMAND' neutral \
                    "Request: $original_request" "Selected: $base_label" '' "$base_command" '' "$base_explanation"
                set -l followup_lines
                if test (count $follow_ups) -gt 0
                    set -a followup_lines 'Suggested follow-ups'
                    for index in (seq (count $follow_ups))
                        set -a followup_lines "$index. $follow_ups[$index]"
                    end
                    set -a followup_lines '' 'What would you like to change?' \
                        "Type a follow-up or choose 1–"(count $follow_ups)'.'
                else
                    set -a followup_lines 'What would you like to change about this command?'
                end
                set -a followup_lines '' 'Enter: update options · Esc: choices · Ctrl+C: cancel'
                __fish_ai_panel 'AI · FOLLOW-UP' refine $followup_lines
            else
                set -l folder (string replace -- "$HOME" '~' "$PWD")
                __fish_ai_panel 'AI · COMMAND ASSISTANT' active \
                    "Folder: $folder" '' 'Describe what you want to do here.' \
                    'Example: search for TODO in TypeScript files' '' \
                    'Enter: get options · Esc: return · Ctrl+C: cancel'
            end
            set -g fish_bind_mode fish_ai
            read --prompt "__fish_ai_read_prompt $ai_mode" --command "$draft" request
            set -l read_status $status
            set -g fish_bind_mode "$original_mode"
            if test "$__fish_ai_cancel" -eq 1
                break
            end
            if test "$__fish_ai_back" -eq 1
                set draft "$__fish_ai_read_draft"
                if test "$ai_mode" = refine
                    set cached 1
                    continue
                end
                break
            end
            test "$read_status" -eq 0; or break
            if test "$ai_mode" = refine; and string match -qr '^[1-3]$' -- "$request"
                if test "$request" -le (count $follow_ups)
                    set request "$follow_ups[$request]"
                    printf 'Following up: %s\n' "$request"
                end
            end
            set draft "$request"
            string match -qr '\S' -- "$request"; or continue
        end

        set -l query_status
        if test "$cached" -eq 1
            "$python" "$helper" query --session "$session" --cwd "$PWD" --cached >"$session/reply"
            set query_status $status
        else
            set -l context_args
            if test "$ai_mode" = prompt
                set context_args --new
            end
            printf '%s' "$request" | "$python" "$helper" query --session "$session" --cwd "$PWD" $context_args >"$session/reply"
            set query_status $pipestatus[2]
        end
        set -l was_cached "$cached"
        set cached 0
        if test "$query_status" -ne 0
            # Ctrl-C exits; ordinary errors leave the request available for editing.
            test "$query_status" -ne 130; or break
            printf 'AI request failed. Edit the prompt to retry, or Esc to return.\n' >&2
            continue
        end
        if test "$was_cached" -eq 0
            set generated_mode "$ai_mode"
            set generated_draft "$request"
            if test "$ai_mode" = prompt
                set original_request "$request"
            end
        end
        set -l reply (string split0 <"$session/reply")
        switch "$reply[1]"
            case insert
                if test (count $reply) -eq 2
                    set result "$reply[2]"
                    set result_cursor (string length -- "$result")
                    set inserted 1
                    break
                end
            case refine
                if test (count $reply) -ge 4; and test (count $reply) -le 7
                    if test "$base_command" != "$reply[3]"
                        set draft ''
                    end
                    set ai_mode refine
                    set base_label "$reply[2]"
                    set base_command "$reply[3]"
                    set base_explanation "$reply[4]"
                    set follow_ups $reply[5..-1]
                    continue
                end
            case back
                set ai_mode "$generated_mode"
                set draft "$generated_draft"
                continue
        end
        printf 'fish_ai: invalid picker response\n' >&2
    end

    set -g fish_bind_mode "$original_mode"
    set -e __fish_ai_active __fish_ai_back __fish_ai_cancel __fish_ai_read_draft __fish_ai_ui_color
    command rm -rf -- "$session"
    if test "$inserted" -eq 1
        __fish_ai_panel 'READY TO EDIT' ready 'Command inserted into Fish. Review it, then press Enter to run.'
    end
    commandline --replace -- "$result"
    commandline --cursor "$result_cursor"
    commandline -f repaint
end
