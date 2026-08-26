if status is-interactive
    function __dotfiles_hotkey_guide_on_prompt --on-event fish_prompt
        fish_hotkeys --install-bindings
        fish_hotkeys --startup-tip
        functions --erase __dotfiles_hotkey_guide_on_prompt
    end
end
