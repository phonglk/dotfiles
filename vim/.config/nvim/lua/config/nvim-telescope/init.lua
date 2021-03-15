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

map_telescope('fgac', 'git_commits')
map_telescope('fgc', 'git_commits')
map_telescope('fgb', 'git_commits')
map_telescope('gs', 'git_status')
