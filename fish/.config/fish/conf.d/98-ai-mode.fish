if status is-interactive
    function __dotfiles_ai_on_prompt --on-event fish_prompt
        fish_ai --install-bindings
        functions --erase __dotfiles_ai_on_prompt
    end
end
