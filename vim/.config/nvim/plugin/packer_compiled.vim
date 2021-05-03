" Automatically generated packer.nvim plugin loader code

if !has('nvim-0.5')
  echohl WarningMsg
  echom "Invalid Neovim version for packer.nvim!"
  echohl None
  finish
endif

packadd packer.nvim

try

lua << END
  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time("Luarocks path setup", true)
local package_path_str = "/Users/phonglk/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/Users/phonglk/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/Users/phonglk/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/Users/phonglk/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/Users/phonglk/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time("Luarocks path setup", false)
time("try_loadstring definition", true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s))
  if not success then
    print('Error running ' .. component .. ' for ' .. name)
    error(result)
  end
  return result
end

time("try_loadstring definition", false)
time("Defining packer_plugins", true)
_G.packer_plugins = {
  FastFold = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/FastFold"
  },
  ["barbar.nvim"] = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/barbar.nvim"
  },
  ["codi.vim"] = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/codi.vim"
  },
  fzf = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/fzf"
  },
  ["galaxyline.nvim"] = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/galaxyline.nvim"
  },
  ["git-blame.nvim"] = {
    config = { "\27LJ\2\n5\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\26config.git-blame-nvim\frequire\0" },
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/git-blame.nvim"
  },
  ["gv.vim"] = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/gv.vim"
  },
  ["hop.nvim"] = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/hop.nvim"
  },
  ["lsp-status.nvim"] = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/lsp-status.nvim"
  },
  ["lspkind-nvim"] = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/lspkind-nvim"
  },
  ["lspsaga.nvim"] = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/lspsaga.nvim"
  },
  ["monokai.nvim"] = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/monokai.nvim"
  },
  neoformat = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/neoformat"
  },
  ["nvcode-color-schemes.vim"] = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/nvcode-color-schemes.vim"
  },
  ["nvim-autopairs"] = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/nvim-autopairs"
  },
  ["nvim-bqf"] = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/nvim-bqf"
  },
  ["nvim-colorizer.lua"] = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/nvim-colorizer.lua"
  },
  ["nvim-compe"] = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/nvim-compe"
  },
  ["nvim-highlite"] = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/nvim-highlite"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/nvim-lspconfig"
  },
  ["nvim-lspinstall"] = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/nvim-lspinstall"
  },
  ["nvim-lsputils"] = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/nvim-lsputils"
  },
  ["nvim-spectre"] = {
    config = { "\27LJ\2\n3\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\24config.nvim-spectre\frequire\0" },
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/nvim-spectre"
  },
  ["nvim-tree.lua"] = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/nvim-tree.lua"
  },
  ["nvim-treesitter"] = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/nvim-treesitter"
  },
  ["nvim-treesitter-refactor"] = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/nvim-treesitter-refactor"
  },
  ["nvim-treesitter-textobjects"] = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/nvim-treesitter-textobjects"
  },
  ["nvim-ts-rainbow"] = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/nvim-ts-rainbow"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/nvim-web-devicons"
  },
  ["omni.vim"] = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/omni.vim"
  },
  ["one-nvim"] = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/one-nvim"
  },
  ["packer.nvim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/opt/packer.nvim"
  },
  playground = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/playground"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/plenary.nvim"
  },
  popfix = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/popfix"
  },
  ["popup.nvim"] = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/popup.nvim"
  },
  ["quick-scope"] = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/quick-scope"
  },
  sonokai = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/sonokai"
  },
  ["startuptime.vim"] = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/startuptime.vim"
  },
  ["tagalong.vim"] = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/tagalong.vim"
  },
  tcomment_vim = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/tcomment_vim"
  },
  ["telescope-fzf-native.nvim"] = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/telescope-fzf-native.nvim"
  },
  ["telescope.nvim"] = {
    config = { "\27LJ\2\n5\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\26config.telescope-nvim\frequire\0" },
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/telescope.nvim"
  },
  undotree = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/undotree"
  },
  ["vim-better-whitespace"] = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/vim-better-whitespace"
  },
  ["vim-closetag"] = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/vim-closetag"
  },
  ["vim-devicons"] = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/vim-devicons"
  },
  ["vim-dispatch"] = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/vim-dispatch"
  },
  ["vim-fugitive"] = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/vim-fugitive"
  },
  ["vim-highlightedyank"] = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/vim-highlightedyank"
  },
  ["vim-lion"] = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/vim-lion"
  },
  ["vim-markbar"] = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/vim-markbar"
  },
  ["vim-monokai-tasty"] = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/vim-monokai-tasty"
  },
  ["vim-peekaboo"] = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/vim-peekaboo"
  },
  ["vim-polyglot"] = {
    commands = { "PolyglotEnable" },
    loaded = false,
    needs_bufread = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/opt/vim-polyglot"
  },
  ["vim-sandwich"] = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/vim-sandwich"
  },
  ["vim-sleuth"] = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/vim-sleuth"
  },
  ["vim-smoothie"] = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/vim-smoothie"
  },
  ["vim-startify"] = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/vim-startify"
  },
  ["vim-textobj-entire"] = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/vim-textobj-entire"
  },
  ["vim-textobj-quotes"] = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/vim-textobj-quotes"
  },
  ["vim-textobj-user"] = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/vim-textobj-user"
  },
  ["vim-vsnip"] = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/vim-vsnip"
  },
  ["vim-vsnip-integ"] = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/vim-vsnip-integ"
  },
  ["vim-which-key"] = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/vim-which-key"
  },
  ["vista.vim"] = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/vista.vim"
  }
}

time("Defining packer_plugins", false)
-- Config for: nvim-spectre
time("Config for nvim-spectre", true)
try_loadstring("\27LJ\2\n3\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\24config.nvim-spectre\frequire\0", "config", "nvim-spectre")
time("Config for nvim-spectre", false)
-- Config for: telescope.nvim
time("Config for telescope.nvim", true)
try_loadstring("\27LJ\2\n5\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\26config.telescope-nvim\frequire\0", "config", "telescope.nvim")
time("Config for telescope.nvim", false)
-- Config for: git-blame.nvim
time("Config for git-blame.nvim", true)
try_loadstring("\27LJ\2\n5\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\26config.git-blame-nvim\frequire\0", "config", "git-blame.nvim")
time("Config for git-blame.nvim", false)

-- Command lazy-loads
time("Defining lazy-load commands", true)
vim.cmd [[command! -nargs=* -range -bang -complete=file PolyglotEnable lua require("packer.load")({'vim-polyglot'}, { cmd = "PolyglotEnable", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
time("Defining lazy-load commands", false)

if should_profile then save_profiles() end

END

catch
  echohl ErrorMsg
  echom "Error in packer_compiled: " .. v:exception
  echom "Please check your config for correctness"
  echohl None
endtry
