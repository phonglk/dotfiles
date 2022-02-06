local M = {}
local global = require "core.global"
local funcs = require "core.funcs"

M.init_vimspector = function()
    if not packer_plugins["vimspector"].loaded then
        vim.cmd [[packadd vimspector]]
    end
    local vimspector_keymaps = {
        {"<A-1>", "<Plug>VimspectorToggleBreakpoint"}, -- Toggle breakpoint
        {"<A-2>", "<Plug>VimspectorContinue"}, -- Start / continue
        {"<A-3>", "<Plug>VimspectorStop"}, -- Stop
        {"<A-4>", "<Plug>VimpectorRestart"}, -- Restart
        {"<A-5>", "<Plug>VimspectorStepOver"}, -- Step over
        {"<A-6>", "<Plug>VimspectorStepInto"}, -- Step into
        {"<A-7>", "<Plug>VimspectorStepOut"}, -- Step out
        {"<A-8>", "<Plug>VimspectorAddFunctionBreakpoint"}, -- Function breakpoint
        {"<A-9>", "<Plug>VimspectorRunToCursor"}, -- Run to cursor
        {"<A-0>", ":VimspectorReset<CR>"} -- Reset
    }
    funcs.keymaps("n", {noremap = false, silent = true}, vimspector_keymaps)
end

M.init_dap = function()
    if not packer_plugins["nvim-dap"].loaded or
        not packer_plugins['nvim-dap-ui'].loaded then
        vim.cmd [[packadd nvim-dap-ui]]
        vim.cmd [[packadd nvim-dap]]
        local dap = require("dap")
        require("dapui").setup({
            icons = {expanded = "⯆", collapsed = "⯈"},
            mappings = {
                expand = {"<CR>", "<2-LeftMouse>"},
                open = "o",
                remove = "d",
                edit = "e"
            },
            sidebar = {
                open_on_start = true,
                elements = {"scopes", "breakpoints", "stacks", "watches"},
                width = 40,
                position = "left"
            },
            tray = {
                open_on_start = true,
                elements = {"repl"},
                height = 10,
                position = "bottom"
            },
            floating = {max_height = nil, max_width = nil}
        })
        vim.fn.sign_define("DapBreakpoint",
                           {text = "●", texthl = "", linehl = "", numhl = ""})
        vim.fn.sign_define("DapStopped", {
            text = "●▶",
            texthl = "",
            linehl = "",
            numhl = ""
        })
        vim.fn.sign_define("DapLogPoint",
                           {text = "▶", texthl = "", linehl = "", numhl = ""})

        dap.adapters.cpp = {
            type = "executable",
            attach = {pidProperty = "pid", pidSelect = "ask"},
            command = "lldb-vscode",
            name = "lldb"
        }
        dap.configurations.cpp = {
            {
                type = "cpp",
                request = "launch",
                name = "Launch",
                program = function()
                    return vim.fn.input("Path to executable: ",
                                        vim.fn.getcwd() .. global.path_sep,
                                        "file")
                end,
                args = {},
                cwd = "${workspaceFolder}",
                env = function()
                    local variables = {}
                    for k, v in pairs(vim.fn.environ()) do
                        table.insert(variables, string.format("%s=%s", k, v))
                    end
                    return variables
                end,
                stopOnEntry = false
            }
        }

        dap.adapters.dart = {
            type = "executable",
            command = "node",
            args = {
                os.getenv("HOME") .. "/sdk/Dart-Code/out/dist/debug.js", "dart"
            }
        }
        dap.configurations.dart = {
            {
                type = "dart",
                name = "Launch flutter",
                request = "launch",
                dartSdkPath = os.getenv("HOME") .. "/sdk/flutter",
                flutterSdkPath = os.getenv("HOME") .. "/sdk/flutter",
                program = function()
                    return vim.fn.input("Path to executable: ",
                                        vim.fn.getcwd() .. global.path_sep,
                                        "file")
                end,
                cwd = "${workspaceFolder}"
            }
        }

        dap.adapters.go = function(callback, config)
            local handle
            local pid_or_err
            local port = 38697
            handle, pid_or_err = vim.loop.spawn("dlv", {
                args = {"dap", "-l", "127.0.0.1:" .. port},
                detached = true
            }, function(code)
                handle:close()
                print("Delve exited with exit code: " .. code)
            end)
            vim.defer_fn(function()
                callback({type = "server", host = "127.0.0.1", port = port})
            end, 100)
        end
        dap.configurations.go = {
            {
                type = "go",
                name = "Debug",
                request = "launch",
                program = function()
                    return vim.fn.input("Path to executable: ",
                                        vim.fn.getcwd() .. global.path_sep,
                                        "file")
                end
            }, {
                type = "go",
                name = "Debug test", -- configuration for debugging test files
                request = "launch",
                mode = "test",
                program = function()
                    return vim.fn.input("Path to executable: ",
                                        vim.fn.getcwd() .. global.path_sep,
                                        "file")
                end
            }
        }

        dap.adapters.javascript = {
            type = 'executable',
            command = 'node',
            args = {
                os.getenv('HOME') ..
                    '/dev/microsoft/vscode-node-debug2/out/src/nodeDebug.js'
            }
        }
        dap.configurations.javascript = {
            {
                type = "typescript",
                request = "launch",
                name = "Launch",
                program = function()
                    return vim.fn.input("Path to executable: ",
                                        vim.fn.getcwd() .. global.path_sep,
                                        "file")
                end,
                cwd = "${workspaceFolder}",
                outFiles = {"${workspaceRoot}/dist/js/*"},
                sourceMaps = true,
                protocol = "inspector",
                console = "integratedTerminal"
            }
        }

        dap.adapters.typescript = {
            type = "executable",
            command = "node",
            args = {
                os.getenv("HOME") ..
                    "/sdk/vscode-node-debug2/out/src/nodeDebug.js"
            }
        }
        dap.configurations.typescript = {
            {
                type = "typescript",
                request = "launch",
                name = "Launch",
                program = function()
                    return vim.fn.input("Path to executable: ",
                                        vim.fn.getcwd() .. global.path_sep,
                                        "file")
                end,
                cwd = "${workspaceFolder}",
                outFiles = {"${workspaceRoot}/dist/js/*"},
                sourceMaps = true,
                protocol = "inspector",
                console = "integratedTerminal"
            }
        }

        dap.adapters.python = {
            type = "executable",
            command = "python",
            args = {"-m", "debugpy.adapter"}
        }
        dap.configurations.python = {
            {
                type = "python",
                request = "launch",
                name = "Launch",
                program = function()
                    return vim.fn.input("Path to executable: ",
                                        vim.fn.getcwd() .. global.path_sep,
                                        "file")
                end,
                pythonPath = function()
                    return global.home .. "/.pyenv/shims/python"
                end
            }
        }

        dap.adapters.rust = {
            type = "executable",
            attach = {pidProperty = "pid", pidSelect = "ask"},
            command = "lldb-vscode",
            env = {LLDB_LAUNCH_FLAG_LAUNCH_IN_TTY = "YES"},
            name = "lldb"
        }
        dap.configurations.rust = {
            {
                type = "rust",
                request = "launch",
                name = "Launch",
                program = function()
                    return vim.fn.input("Path to executable: ",
                                        vim.fn.getcwd() .. global.path_sep,
                                        "file")
                end,
                args = {},
                cwd = "${workspaceFolder}",
                env = function()
                    local variables = {}
                    for k, v in pairs(vim.fn.environ()) do
                        table.insert(variables, string.format("%s=%s", k, v))
                    end
                    return variables
                end,
                stopOnEntry = false
            }
        }

        require("dap.ext.vscode").load_launchjs()
    end
    local dap_keymaps = {
        {"<A-1>", "<Cmd>DapToggleBreakpoint<CR>"}, -- Toggle breakpoint
        {"<A-2>", "<Cmd>DapStart<CR>"}, -- Start / continue
        {"<A-3>", "<Cmd>DapStop<CR>"}, -- Stop
        {"<A-4>", "<Cmd>DapRestart<CR>"}, -- Restart
        {"<A-5>", "<Cmd>DapStepOver<CR>"}, -- Step over
        {"<A-6>", "<Cmd>DapStepInto<CR>"}, -- Step into
        {"<A-7>", "<Cmd>DapStepOut<CR>"}, -- Step out
        {"<A-8>", "<Cmd>DapPause<CR>"}, -- Pause
        {"<A-9>", "<Cmd>DapToggleRepl<CR>"}, -- Toggle repl
        {"<A-0>", "<Cmd>DapGetSession<CR>"} -- Get session
    }
    funcs.keymaps("n", {noremap = false, silent = true}, dap_keymaps)
end

return M
