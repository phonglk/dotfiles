local status, fzflua = pcall(require, "fzf-lua")
if (not status) then return end

fzflua.setup {
  winopts = { -- Only valid when using a float window
    height = 0.65,
    width = 0.7,
    row = 0.9,
    col = 200,
    preview = {
      default = 'bat_native',
      title = false,
      wrap = 'nowrap',
      vertical = 'up:80%',
      layout = 'vertical'
    }
  },
  files = {
    cmd = 'rg --files --hidden --follow --glob "!.git/*"',
  },
  grep = {
    cmd = "rg --vimgrep",
    color_icons = false,
    file_icons = false,
  }
}
