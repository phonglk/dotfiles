local nvim_lsp = require('lspconfig')
local lsp_status = require('lsp-status')
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }
  -- buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gD', ':Lspsaga lsp_finder<CR>', opts)
  -- buf_set_keymap('n', 'gd', ':Telescope lsp_definitions<CR>', opts)
  buf_set_keymap('n', 'gd', ':Lspsaga preview_definition<CR>', opts)
  -- buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gr', ':Telescope lsp_references<CR>', opts)
  -- buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', 'gy', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  -- buf_set_keymap('n', 'rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', 'rn', ':Lspsaga rename<CR>', opts)
  -- buf_set_keymap('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'ga', ':Lspsaga code_action<CR>', opts)
  buf_set_keymap('v', 'ga', ':<C-U>Lspsaga range_code_action<CR>', opts)
  -- buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  -- buf_set_keymap('v', 'gs', ':Lspsaga signature_help<CR>', opts)
  -- buf_set_keymap('n', 'sl', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', 'sl', ':Lspsaga show_line_diagnostics<CR>', opts)
  buf_set_keymap('n', 'sd', ':Telescope lsp_document_diagnostics<CR>', opts)
  -- buf_set_keymap('n', 'g[', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', 'g[', ':Lspsaga diagnostic_jump_prev<CR>', opts)
  -- buf_set_keymap('n', 'g]', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', 'g]', ':Lspsaga diagnostic_jump_next<CR>', opts)
  -- buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'K', ':Lspsaga hover_doc<CR>', opts)

  -- --- scroll down hover doc or scroll in definition preview
  -- buf_set_keymap('n', '<C-f>', "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>", opts)
  -- -- scroll up hover doc
  -- buf_set_keymap('n', '<C-b>', "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>", opts)

  -- buf_set_keymap('n', 'gt', ':Lspsaga open_floaterm<CR>', opts)
  -- buf_set_keymap('t', 'gt', [[<C-\><C-n>:Lspsaga close_floaterm<CR>]], opts)

  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  -- buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

  buf_set_keymap('n', 'gs', ':Telescope lsp_document_symbols<CR>', opts)
  buf_set_keymap('n', '<leader>ws', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>', opts)

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  elseif client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("n", "<leader>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
  end

  -- Set autocommands conditional on server_capabilities
  -- if client.resolved_capabilities.document_highlight then
  --   vim.api.nvim_exec([[
  --     hi LspReferenceRead cterm=bold ctermbg=red guibg=#4e4e4e
  --     hi LspReferenceText cterm=bold ctermbg=red guibg=#4e4e4e
  --     hi LspReferenceWrite cterm=bold ctermbg=red guibg=#4e4e4e
  --     augroup lsp_document_highlight
  --       autocmd! * <buffer>
  --       autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
  --       autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
  --     augroup END
  --   ]], false)
  -- end
end

lsp_status.register_progress()
local kind_labels_mt = {__index = function(_, k) return k end}
  local kind_labels = {}
  lsp_status.config({
    kind_labels = kind_labels,
    indicator_errors = "?",
    indicator_warnings = "!",
    indicator_info = "i",
    indicator_hint = "?",
    -- the default is a wide codepoint which breaks absolute and relative
    -- line counts if placed before airline's Z section
    status_symbol = "",
    kind_labels
  })

-- Use a loop to conveniently both setup defined servers
-- and map buffer local keybindings when the language server attaches
local servers = { "tsserver", "bashls" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup { on_attach = on_attach }
end

local system_name
if vim.fn.has("mac") == 1 then
  system_name = "macOS"
elseif vim.fn.has("unix") == 1 then
  system_name = "Linux"
elseif vim.fn.has('win32') == 1 then
  system_name = "Windows"
else
  print("Unsupported system for sumneko")
end

local sumneko_root_path = vim.fn.stdpath('cache')..'/lspconfig/lua-language-server'
local sumneko_binary = sumneko_root_path.."/bin/"..system_name.."/lua-language-server"

require'lspconfig'.sumneko_lua.setup {
  cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"};
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = vim.split(package.path, ';'),
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = {
          [vim.fn.expand('$VIMRUNTIME/lua')] = true,
          [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
        },
      },
    },
  },
}

-- vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
--   vim.lsp.diagnostic.on_publish_diagnostics, {
--     virtual_text = {
--       severity_limit = "Warning",
--     },
--   }
-- )

-- config for lspkind-nvim plugin
require('lspkind').init({
    -- with_text = true,
    -- symbol_map = {
    --   Text = '',
    --   Method = 'ƒ',
    --   Function = '',
    --   Constructor = '',
    --   Variable = '',
    --   Class = '',
    --   Interface = 'ﰮ',
    --   Module = '',
    --   Property = '',
    --   Unit = '',
    --   Value = '',
    --   Enum = '了',
    --   Keyword = '',
    --   Snippet = '﬌',
    --   Color = '',
    --   File = '',
    --   Folder = '',
    --   EnumMember = '',
    --   Constant = '',
    --   Struct = ''
    -- },
})

-- for nvim-lsputils
-- vim.lsp.handlers['textDocument/codeAction'] = require'lsputil.codeAction'.code_action_handler
-- vim.lsp.handlers['textDocument/references'] = require'lsputil.locations'.references_handler
-- vim.lsp.handlers['textDocument/definition'] = require'lsputil.locations'.definition_handler
-- vim.lsp.handlers['textDocument/declaration'] = require'lsputil.locations'.declaration_handler
-- vim.lsp.handlers['textDocument/typeDefinition'] = require'lsputil.locations'.typeDefinition_handler
-- vim.lsp.handlers['textDocument/implementation'] = require'lsputil.locations'.implementation_handler
-- vim.lsp.handlers['textDocument/documentSymbol'] = require'lsputil.symbols'.document_handler
-- vim.lsp.handlers['workspace/symbol'] = require'lsputil.symbols'.workspace_handler

-- lspsaga
local saga = require 'lspsaga'
saga.init_lsp_saga{
  max_preview_lines = 10,
  code_action_keys = {
    quit = '<Esc>',exec = '<CR>'
  },
  rename_action_keys = {
    quit = '<Esc>',exec = '<CR>'  -- quit can be a table
  },
}

-- linter
nvim_lsp.diagnosticls.setup {
    filetypes = {"javascript", "typescript"},
    init_options = {
        linters = {
            eslint = {
                command = "./node_modules/.bin/eslint",
                rootPatterns = {".git"},
                debounce = 100,
                args = {
                    "--stdin",
                    "--stdin-filename",
                    "%filepath",
                    "--format",
                    "json"
                },
                sourceName = "eslint",
                parseJson = {
                    errorsRoot = "[0].messages",
                    line = "line",
                    column = "column",
                    endLine = "endLine",
                    endColumn = "endColumn",
                    message = "${message} [${ruleId}]",
                    security = "severity"
                },
                securities = {
                    [2] = "error",
                    [1] = "warning"
                }
            },
        filetypes = {
            javascript = "eslint",
            typescript = "eslint"
        }
    }
}
}
-- sign define
vim.api.nvim_exec([[
  sign define LspDiagnosticsSignError text= texthl=LspDiagnosticsError linehl= numhl=LspDiagnosticsError
  sign define LspDiagnosticsSignWarning text= texthl=LspDiagnosticsVirtualTextWarning linehl= numhl=LspDiagnosticsVirtualTextWarning
  sign define LspDiagnosticsSignInformation text= texthl=LspDiagnosticsInformation linehl= numhl=LspDiagnosticsInformation
  sign define LspDiagnosticsSignHint text= texthl=LspDiagnosticsHint linehl= numhl=LspDiagnosticsHint
]], false)

