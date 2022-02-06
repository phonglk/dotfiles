local config = {}

function config.colorize()
    require"colorizer".setup({"*"}, {
        RGB = true,
        RRGGBB = true,
        RRGGBBAA = true,
        rgb_fn = true,
        hsl_fn = true,
        css = true,
        css_fn = true
    })
end

function config.vim_dadbod_ui()
    if packer_plugins["vim-dadbod"] and not packer_plugins["vim-dadbod"].loaded then
        vim.cmd [[packadd vim-dadbod]]
    end
    vim.g.db_ui_show_help = 0
    vim.g.db_ui_win_position = "left"
    vim.g.db_ui_use_nerd_fonts = 1
    vim.g.db_ui_winwidth = 35
    vim.api.nvim_set_keymap("n", "<leader>Du", ":DBUIToggle<CR>",
                            {noremap = true, silent = true})
    vim.api.nvim_set_keymap("n", "<leader>Df", ":DBUIFindBuffer<CR>",
                            {noremap = true, silent = true})
    vim.api.nvim_set_keymap("n", "<leader>Dr", ":DBUIRenameBuffer<CR>",
                            {noremap = true, silent = true})
    vim.api.nvim_set_keymap("n", "<leader>Dl", ":DBUILastQueryInfo<CR>",
                            {noremap = true, silent = true})
    vim.g.db_ui_auto_execute_table_helpers = true
end

function config.whichkey()
    local wk = require("whichkey_setup")
    wk.config {
        hide_statusline = false,
        default_keymap_settings = {silent = true, noremap = false}
    }
    vim.g.which_key_display_names = {
        ["<CR>"] = "↵",
        ["<TAB>"] = "⇆",
        [" "] = "SPC"
    }
    vim.g.which_key_sep = "→"
    vim.g.which_key_timeout = 10
    vim.g.which_key_use_floating_win = 0
    vim.g.which_key_max_size = 0
    vim.cmd("autocmd! FileType which_key")
    vim.cmd(
        "autocmd FileType which_key set laststatus=0 noshowmode noruler | autocmd BufLeave <buffer> set laststatus=2 noshowmode ruler")
    local keymap = {
        [";"] = {"<Cmd>Dashboard<CR>", "home screen"},
        ["*"] = {"<Cmd>DogeGenerate<CR>", "documentation generator"},
        ["/"] = {"<Cmd>CommentToggle<CR>", "comment"},
        ["e"] = {"<Cmd>NvimTreeToggle<CR>", "explorer"},
        ["u"] = {"<Cmd>Vifm<CR>", "vifm"},
        ["n"] = {"<Cmd>Neoformat<CR>", "neoformal"},
        ["M"] = {"<Cmd>MarkdownPreviewToggle<CR>", "markdown preview toggle"},
        ["o"] = {"<Cmd>SymbolsOutline<CR>", "symbols outline"},
        ["b"] = {
            name = "+buffer",
            [">"] = {"<Cmd>BufferMoveNext<CR>", "move next"},
            ["<"] = {"<Cmd>BufferMovePrevious<CR>", "move prev"},
            ["b"] = {"<Cmd>BufferPick<CR>", "pick buffer"},
            ["n"] = {"<Cmd>bnext<CR>", "next buffer"},
            ["p"] = {"<Cmd>bprevious<CR>", "prev buffer"}
        },
        ["p"] = {
            name = "+path",
            ["g"] = {"<Cmd>SetGlobalPath<CR>", "set global path"},
            ["w"] = {"<Cmd>SetWindowPath<CR>", "set window path"}
        },
        ["d"] = {
            name = "+database",
            ["u"] = {"<Cmd>DBUIToggle<CR>", "db ui toggle"},
            ["f"] = {"<Cmd>DBUIFindBuffer<CR>", "db find buffer"},
            ["r"] = {"<Cmd>DBUIRenameBuffer<CR>", "db rename buffer"},
            ["l"] = {"<Cmd>DBUILastQueryInfo<CR>", "db last query"}
        },
        ["."] = {
            name = "+virtualtext",
            ["s"] = {"<Cmd>LspVirtualTextShow<CR>", "virtual text show"},
            ["h"] = {"<Cmd>LspVirtualTextHide<CR>", "virtual text hide"}
        },
        ["l"] = {
            name = "+lsp",
            ["r"] = {"<Cmd>LspRename<CR>", "rename"},
            ["h"] = {"<Cmd>LspHover<CR>", "hover"},
            ["d"] = {"<Cmd>LspDeclaration<CR>", "declaration"},
            ["w"] = {
                name = "+workspace",
                ["a"] = {
                    "<Cmd>LspAddToWorkspaceFolder<CR>",
                    "add to workspace folder"
                },
                ["r"] = {
                    "<Cmd>LspRemoveWorkspaceFolder<CR>",
                    "remove workspace folder"
                },
                ["l"] = {
                    "<Cmd>LspListWorkspaceFolders<CR>", "list workspace folder"
                }
            },
            ["s"] = {
                name = "+symbol",
                ["D"] = {"<Cmd>LspDocumentSymbol<CR>", "document symbol"},
                ["W"] = {"<Cmd>LspWorkspaceSymbol<CR>", "workspace symbol"}
            },
            ["R"] = {
                name = "+references",
                ["r"] = {"<Cmd>LspReferences<CR>", "references"},
                ["c"] = {"<Cmd>LspClearReferences<CR>", "clear references"}
            },
            ["a"] = {
                name = "+action",
                ["r"] = {"<Cmd>LspCodeAction<CR>", "code action"},
                ["c"] = {"<Cmd>LspRangeCodeAction<CR>", "range code action"}
            },
            ["f"] = {
                name = "+formatting",
                ["d"] = {"<Cmd>LspFormatting<CR>", "formatting"},
                ["r"] = {"<Cmd>LspRangeFormatting<CR>", "range formatting"},
                ["s"] = {"<Cmd>LspFormattingSync<CR>", "sync formatting"}
            },
            ["D"] = {
                name = "+definition",
                ["d"] = {"<Cmd>LspDefinition<CR>", "definition"},
                ["t"] = {"<Cmd>LspTypeDefinition<CR>", "type definition"}
            },
            ["g"] = {
                name = "+diagnostics",
                ["a"] = {"<Cmd>LspGetAll<CR>", "get all"},
                ["n"] = {"<Cmd>LspGetNext<CR>", "next"},
                ["p"] = {"<Cmd>LspGoToNext<CR>", "go to prev"},
                ["N"] = {"<Cmd>LspGoToPrev<CR>", "go to next"},
                ["P"] = {"<Cmd>LspGetPrev<CR>", "prev"}
            }
        },
        ["g"] = {
            name = "+git",
            ["b"] = {"<Cmd>GitSignsBlameLine<CR>", "blame"},
            ["B"] = {"<Cmd>GBrowse<CR>", "browse"},
            ["d"] = {"<Cmd>Git diff<CR>", "diff"},
            ["j"] = {"<Cmd>GitSignsNextHunk<CR>", "next hunk"},
            ["k"] = {"<Cmd>GitSignsPrevHunk<CR>", "prev hunk"},
            ["l"] = {"<Cmd>Git log<CR>", "log"},
            ["p"] = {"<Cmd>GitSignsPreviewHunk<CR>", "preview hunk"},
            ["R"] = {"<Cmd>GitSignsResetBuffer<CR>", "reset buffer"},
            ["s"] = {"<Cmd>GitSignsStageHunk<CR>", "stage hunk"},
            ["u"] = {"<Cmd>GitSignsUndoStageHunk<CR>", "undo stage hunk"},
            ["r"] = {"<Cmd>GitSignsResetHunk<CR>", "reset stage hunk"},
            ["S"] = {"<Cmd>Gstatus<CR>", "status"},
            ["n"] = {"<Cmd>Neogit<CR>", "neogit"}
        },
        ["G"] = {
            name = "+gist",
            ["b"] = {"<Cmd>Gist -b<CR>", "post gist browser"},
            ["d"] = {"<Cmd>Gist -d<CR>", "delete gist"},
            ["e"] = {"<Cmd>Gist -e<CR>", "edit gist"},
            ["l"] = {"<Cmd>Gist -l<CR>", "list public gists"},
            ["s"] = {"<Cmd>Gist -ls<CR>", "list starred gists"},
            ["m"] = {"<Cmd>Gist -m<CR>", "post gist all buffers"},
            ["p"] = {"<Cmd>Gist -p<CR>", "post public gist"},
            ["P"] = {"<Cmd>Gist -P<CR>", "post private gist"}
        },
        ["m"] = {
            name = "+bookmark",
            ["t"] = {"<Cmd>BookmarkToggle<CR>", "toggle bookmark"},
            ["n"] = {"<Cmd>BookmarkNext<CR>", "next bookmark"},
            ["p"] = {"<Cmd>BookmarkPrev<CR>", "prev bookmark"}
        },
        ["F"] = {
            name = "+fold",
            ["m"] = {"<Cmd>:set foldmethod=manual<CR>", "manual (default)"},
            ["i"] = {"<Cmd>:set foldmethod=indent<CR>", "indent"},
            ["e"] = {"<Cmd>:set foldmethod=expr<CR>", "expr"},
            ["d"] = {"<Cmd>:set foldmethod=diff<CR>", "diff"},
            ["M"] = {"<Cmd>:set foldmethod=marker<CR>", "marker"}
        },
        ["s"] = {
            name = "+spectre",
            ["d"] = {
                '<Cmd>lua require("spectre").delete()<CR>',
                "toggle current item"
            },
            ["g"] = {
                '<Cmd>lua require("spectre.actions").select_entry()<CR>',
                "goto current file"
            },
            ["q"] = {
                '<Cmd>lua require("spectre.actions").send_to_qf()<CR>',
                "send all item to quickfix"
            },
            ["m"] = {
                '<Cmd>lua require("spectre.actions").replace_cmd()<CR>',
                "input replace vim command"
            },
            ["o"] = {
                '<Cmd>lua require("spectre").show_options()<CR>', "show option"
            },
            ["R"] = {
                '<Cmd>lua require("spectre.actions").run_replace()<CR>',
                "replace all"
            },
            ["v"] = {
                '<Cmd>lua require("spectre").change_view()<CR>',
                "change result view mode"
            },
            ["c"] = {
                '<Cmd>lua require("spectre").change_options("ignore-case")<CR>',
                "toggle ignore case"
            },
            ["h"] = {
                '<Cmd>lua require("spectre").change_options("hidden")<CR>',
                "toggle search hidden"
            }
        },
        ["t"] = {
            name = "+terminal",
            ["g"] = {"<Cmd>FloatermNew lazygit<CR>", "git"},
            ["d"] = {"<Cmd>FloatermNew lazydocker<CR>", "docker"},
            ["n"] = {"<Cmd>FloatermNew lazynpm<CR>", "npm"}
        }
    }
    wk.register_keymap("leader", keymap, {mode = "n"})
end

function config.rooter() vim.g.rooter_silent_chdir = 1 end

return config
