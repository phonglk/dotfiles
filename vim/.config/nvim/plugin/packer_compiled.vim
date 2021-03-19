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
local package_path_str = "/Users/phonglk/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/Users/phonglk/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/Users/phonglk/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/Users/phonglk/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/Users/phonglk/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s))
  if not success then
    print('Error running ' .. component .. ' for ' .. name)
    error(result)
  end
  return result
end

_G.packer_plugins = {
  ["barbar.nvim"] = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/barbar.nvim"
  },
  ["galaxyline.nvim"] = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/galaxyline.nvim"
  },
  ["gitsigns.nvim"] = {
    config = { "\27LJ\2\n6\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\rgitsigns\frequire\0" },
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/gitsigns.nvim"
  },
  ["gruvbox-material"] = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/gruvbox-material"
  },
  ["gv.vim"] = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/gv.vim"
  },
  ["lspkind-nvim"] = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/lspkind-nvim"
  },
  ["lspsaga.nvim"] = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/lspsaga.nvim"
  },
  neoformat = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/neoformat"
  },
  ["nlua.nvim"] = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/nlua.nvim"
  },
  ["nvim-autopairs"] = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/nvim-autopairs"
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
  ["nvim-ts-rainbow"] = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/nvim-ts-rainbow"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/nvim-web-devicons"
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
  ["plenary.nvim"] = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/plenary.nvim"
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
  tcomment_vim = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/tcomment_vim"
  },
  ["telescope.nvim"] = {
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
  ["vim-easymotion"] = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/vim-easymotion"
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
  ["vim-monokai"] = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/vim-monokai"
  },
  ["vim-monokai-tasty"] = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/vim-monokai-tasty"
  },
  ["vim-peekaboo"] = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/vim-peekaboo"
  },
  ["vim-sandwich"] = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/vim-sandwich"
  },
  ["vim-snippets"] = {
    loaded = true,
    path = "/Users/phonglk/.local/share/nvim/site/pack/packer/start/vim-snippets"
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
  }
}

-- Config for: gitsigns.nvim
try_loadstring("\27LJ\2\n6\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\rgitsigns\frequire\0", "config", "gitsigns.nvim")
END

catch
  echohl ErrorMsg
  echom "Error in packer_compiled: " .. v:exception
  echom "Please check your config for correctness"
  echohl None
endtry
