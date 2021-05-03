local utils = require('../../utils')
local function map_telescope(keys, builtin_function)
  utils.map('n', '<leader>'..keys, ":lua require('telescope.builtin')."..builtin_function.."()<cr>")
end

map_telescope('b', 'buffers')
map_telescope('i', 'find_files')
map_telescope('s', 'live_grep')
map_telescope('c', 'commands')

map_telescope('fh', 'help_tags')
map_telescope('fb', 'file_browser')
map_telescope('fq', 'quickfix')
map_telescope('fvo', 'vim_options')
map_telescope('fts', 'treesitter')
map_telescope('fkm', 'keymaps')
map_telescope('fcs', 'colorscheme')

map_telescope('gac', 'git_commits')
map_telescope('gc', 'git_bcommits')
map_telescope('gb', 'git_branches')
map_telescope('gs', 'git_status')

map_telescope('lt', 'builtin')

map_telescope('/', 'current_buffer_fuzzy_find')

local actions = require('telescope.actions')
local telescope = require('telescope')
telescope.setup{
  extensions = {
    fzf = {
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    }
  },
  defaults = {
    mappings = {
      i = {
        ["<esc>"] = actions.close
      },
    },
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case'
    },
    prompt_position = "top",
    prompt_prefix = "> ",
    selection_caret = "> ",
    entry_prefix = "  ",
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "ascending",
    layout_strategy = "horizontal",
    layout_defaults = {
      horizontal = {
        mirror = false,
      },
      vertical = {
        mirror = false,
      },
    },
    file_sorter =  require'telescope.sorters'.get_fuzzy_file,
    file_ignore_patterns = {},
    generic_sorter =  require'telescope.sorters'.get_generic_fuzzy_sorter,
    shorten_path = true,
    winblend = 10,
    width = 0.75,
    preview_cutoff = 120,
    results_height = 1,
    results_width = 0.8,
    border = {},
    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
    color_devicons = true,
    use_less = true,
    set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
    file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
    grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
    qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,

    -- Developer configurations: Not meant for general override
    buffer_previewer_maker = require'telescope.previewers'.buffer_previewer_maker
  }
}

telescope.load_extension('fzf')
