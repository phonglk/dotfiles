local config = {}

-- function config.clap()
--     vim.g.clap_layout = {relative = "editor"}
--     vim.clap_provider_grep_opts = '--hidden -g "!.git/ target/"'
--     vim.g.clap_fuzzy_match_hl_groups = {
--         {31, "#00839F"},
--         {31, "#00839F"},
--         {31, "#00839F"},
--         {31, "#00839F"},
--         {31, "#00839F"},
--         {31, "#00839F"},
--         {31, "#00839F"},
--         {31, "#00839F"},
--         {31, "#00839F"}
--     }
--     vim.api.nvim_exec(
--         [[
--         function! MyShiftTab() abort
--             call g:clap.input.set('')
--             call g:clap.provider._().bs_action()
--             return ''
--         endfunction
--         autocmd FileType clap_input inoremap <silent> <buffer> <S-Tab> <C-R>=MyShiftTab()<CR>
--     ]],
--         true
--     )
-- end

function config.spectre()
    if not packer_plugins["plenary.nvim"].loaded or
        not packer_plugins["popup.nvim"].loaded then
        vim.cmd [[packadd plenary.nvim]]
        vim.cmd [[packadd popup.nvim]]
    end
    require("spectre").setup({
        color_devicons = true,
        line_sep_start = "-----------------------------------------",
        result_padding = "|  ",
        line_sep = "-----------------------------------------",
        highlight = {
            ui = "String",
            search = "DiffChange",
            replace = "DiffDelete"
        },
        mapping = {
            ["delete_line"] = nil,
            ["enter_file"] = nil,
            ["send_to_qf"] = nil,
            ["replace_cmd"] = nil,
            ["show_option_menu"] = nil,
            ["run_replace"] = nil,
            ["change_view_mode"] = nil,
            ["toggle_ignore_case"] = nil,
            ["toggle_ignore_hidden"] = nil
        },
        find_engine = {
            ["rg"] = {
                cmd = "rg",
                args = {
                    "--color=never", "--no-heading", "--with-filename",
                    "--line-number", "--column"
                },
                options = {
                    ["ignore-case"] = {
                        value = "--ignore-case",
                        icon = "[I]",
                        desc = "ignore case"
                    },
                    ["hidden"] = {
                        value = "--hidden",
                        desc = "hidden file",
                        icon = "[H]"
                    }
                }
            },
            ["ag"] = {
                cmd = "ag",
                args = {"--vimgrep", "-s"},
                options = {
                    ["ignore-case"] = {
                        value = "-i",
                        icon = "[I]",
                        desc = "ignore case"
                    },
                    ["hidden"] = {
                        value = "--hidden",
                        desc = "hidden file",
                        icon = "[H]"
                    }
                }
            }
        },
        replace_engine = {
            ["sed"] = {cmd = "sed", args = nil},
            options = {
                ["ignore-case"] = {
                    value = "--ignore-case",
                    icon = "[I]",
                    desc = "ignore case"
                }
            }
        },
        default = {
            find = {cmd = "rg", options = {"ignore-case"}},
            replace = {cmd = "sed"}
        },
        replace_vim_cmd = "cfdo",
        is_open_target_win = true,
        is_insert_mode = false
    })
end

function config.suda() vim.g.suda_smart_edit = 1 end

function config.comment() require("nvim_comment").setup() end

function config.autopairs()
    if not packer_plugins["nvim-treesitter"].loaded then
        vim.cmd [[packadd nvim-treesitter]]
    end
    require("nvim-autopairs").setup()
    local npairs = require("nvim-autopairs")

    local function imap(lhs, rhs, opts)
        local options = {noremap = false}
        if opts then options = vim.tbl_extend("force", options, opts) end
        vim.api.nvim_set_keymap("i", lhs, rhs, options)
    end

    _G.MUtils = {}

    vim.g.completion_confirm_key = ""
    MUtils.completion_confirm = function()
        if vim.fn.pumvisible() ~= 0 then
            if vim.fn.complete_info()["selected"] ~= -1 then
                vim.fn["compe#confirm"]()
                return npairs.esc("")
            else
                vim.defer_fn(function()
                    vim.fn["compe#confirm"]("<cr>")
                end, 20)
                return npairs.esc("<c-n>")
            end
        else
            return npairs.check_break_line_char()
        end
    end

    MUtils.completion_confirm = function()
        if vim.fn.pumvisible() ~= 0 then
            if vim.fn.complete_info()["selected"] ~= -1 then
                vim.fn["compe#confirm"]()
                return npairs.esc("")
            else
                vim.api.nvim_select_popupmenu_item(0, false, false, {})
                vim.fn["compe#confirm"]()
                return npairs.esc("<c-n>")
            end
        else
            return npairs.check_break_line_char()
        end
    end

    MUtils.tab = function()
        if vim.fn.pumvisible() ~= 0 then
            return npairs.esc("<C-n>")
        else
            if vim.fn["vsnip#available"](1) ~= 0 then
                vim.fn.feedkeys(string.format("%c%c%c(vsnip-expand-or-jump)",
                                              0x80, 253, 83))
                return npairs.esc("")
            else
                return npairs.esc("<Tab>")
            end
        end
    end

    MUtils.s_tab = function()
        if vim.fn.pumvisible() ~= 0 then
            return npairs.esc("<C-p>")
        else
            if vim.fn["vsnip#jumpable"](-1) ~= 0 then
                vim.fn.feedkeys(string.format("%c%c%c(vsnip-jump-prev)", 0x80,
                                              253, 83))
                return npairs.esc("")
            else
                return npairs.esc("<C-h>")
            end
        end
    end

    vim.api.nvim_set_keymap("i", "<CR>", "v:lua.MUtils.completion_confirm()",
                            {expr = true, noremap = true})
    imap("<Tab>", "v:lua.MUtils.tab()", {expr = true, noremap = true})
    imap("<S-Tab>", "v:lua.MUtils.s_tab()", {expr = true, noremap = true})
end

function config.bookmarks()
    vim.g.bookmark_no_default_key_mappings = 1
    vim.g.bookmark_sign = ""
end

function config.doge() vim.g.doge_mapping = "<Leader>*" end

function config.gitsigns()
    if not packer_plugins["plenary.nvim"].loaded then
        vim.cmd [[packadd plenary.nvim]]
    end
    require("gitsigns").setup {
        signs = {
            add = {
                hl = "GitSignsAdd",
                text = " ▎",
                numhl = "GitSignsAddNr",
                linehl = "GitSignsAddLn"
            },
            change = {
                hl = "GitSignsChange",
                text = " ▎",
                numhl = "GitSignsChangeNr",
                linehl = "GitSignsChangeLn"
            },
            delete = {
                hl = "GitSignsDelete",
                -- text = '契',
                text = " ▎",
                numhl = "GitSignsDeleteNr",
                linehl = "GitSignsDeleteLn"
            },
            topdelete = {
                hl = "GitSignsDelete",
                text = " ▎",
                numhl = "GitSignsDeleteNr",
                linehl = "GitSignsDeleteLn"
            },
            changedelete = {
                hl = "GitSignsChange",
                text = " ▎",
                numhl = "GitSignsChangeNr",
                linehl = "GitSignsChangeLn"
            }
        },
        numhl = false,
        linehl = false,
        keymaps = {
            -- Default keymap options
            noremap = true,
            buffer = true
        },
        watch_index = {interval = 1000, follow_files = true},
        current_line_blame = false,
        current_line_blame_delay = 1000,
        current_line_blame_position = 'eol',
        sign_priority = 6,
        update_debounce = 100,
        status_formatter = nil, -- Use default
        word_diff = false,
        use_decoration_api = true,
        use_internal_diff = true
    }
end

function config.diffview()
    local cb = require"diffview.config".diffview_callback
    require"diffview".setup {
        diff_binaries = false,
        file_panel = {width = 35, use_icons = true},
        key_bindings = {
            disable_defaults = false,
            view = {
                ["<tab>"] = cb("select_next_entry"),
                ["<s-tab>"] = cb("select_prev_entry"),
                ["<leader>e"] = cb("focus_files"),
                ["<leader>b"] = cb("toggle_files")
            },
            file_panel = {
                ["j"] = cb("next_entry"),
                ["<down>"] = cb("next_entry"),
                ["k"] = cb("prev_entry"),
                ["<up>"] = cb("prev_entry"),
                ["<cr>"] = cb("select_entry"),
                ["o"] = cb("select_entry"),
                ["<2-LeftMouse>"] = cb("select_entry"),
                ["-"] = cb("toggle_stage_entry"),
                ["S"] = cb("stage_all"),
                ["U"] = cb("unstage_all"),
                ["R"] = cb("refresh_files"),
                ["<tab>"] = cb("select_next_entry"),
                ["<s-tab>"] = cb("select_prev_entry"),
                ["<leader>e"] = cb("focus_files"),
                ["<leader>b"] = cb("toggle_files")
            }
        }
    }
end

function config.blame() vim.g.gitblame_enabled = 0 end

function config.neogit()
    if not packer_plugins["plenary.nvim"].loaded then
        vim.cmd [[packadd plenary.nvim]]
    end
    if not packer_plugins["diffview.nvim"].loaded then
        vim.cmd [[packadd diffview.nvim]]
    end
    require("neogit").setup {
        disable_signs = false,
        disable_context_highlighting = false,
        disable_commit_confirmation = false,
        signs = {
            section = {"", ""},
            item = {"", ""},
            hunk = {"", ""}
        },
        integrations = {diffview = true}
    }
end

function foldsigns() require("foldsigns").setup() end

return config
