vim.api.nvim_exec([[
"@vim-script
let g:vim_monokai_tasty_italic = 1
try
  colorscheme vim-monokai-tasty
  catch
endtry

function! Highlight(group, fg, bg, style)
  exec "hi " . a:group . " ctermfg=" . a:fg["cterm"] . " ctermbg=" . a:bg["cterm"] . " cterm=" . a:style["cterm"] . " guifg=" . a:fg["gui"] . " guibg=" . a:bg["gui"] . " gui=" . a:style["gui"]
endfunction



function! CustomTheme()
  let l:yellow = { "cterm": 228, "gui": "#ffff87" }
  let l:purple = { "cterm": 141, "gui": "#af87ff" }
  let l:light_green = { "cterm": 148, "gui": "#A4E400" }
  let l:light_blue = { "cterm": 81, "gui": "#62D8F1" }
  let l:magenta = { "cterm": 197, "gui": "#FC1A70" }
  let l:orange = { "cterm": 208, "gui": "#FF9700" }

  let l:white = { "cterm": 231, "gui": "#ffffff" }
  let l:light_grey = { "cterm": 250, "gui": "#bcbcbc" }
  let l:grey = { "cterm": 245, "gui": "#8a8a8a" }
  let l:dark_grey = { "cterm": 59, "gui": "#5f5f5f" }
  let l:darker_grey = { "cterm": 238, "gui": "#444444" }
  let l:darkest_grey = { "cterm": 238, "gui": "#333333" }
  let l:light_charcoal = { "cterm": 238, "gui": "#2b2b2b" }
  let l:charcoal = { "cterm": 235, "gui": "#262626" }


  let l:danger = { "cterm": 197, "gui": "#ff005f" }
  let l:olive = { "cterm": 64, "gui": "#5f8700" }
  let l:dark_red = { "cterm": 88, "gui": "#870000" }
  let l:blood_red = { "cterm": 52, "gui": "#5f0000" }
  let l:dark_green = { "cterm": 22, "gui": "#005f00" }
  let l:bright_blue = { "cterm": 33, "gui": "#0087ff" }
  let l:purple_slate = { "cterm": 60, "gui": "#5f5f87" }

  let l:none = { "cterm": "NONE", "gui": "NONE" }
  let l:bold = { "cterm": "bold", "gui": "bold" }
  let l:underline = { "cterm": "underline", "gui": "underline" }
  let l:bold_underline = { "cterm": "bold,underline", "gui": "bold,underline" }

  hi CursorLineNR cterm=bold ctermbg=NONE ctermfg=red

  call Highlight("TSCurrentScope", l:none, l:darkest_grey, l:none)
  call Highlight("TSDefinition", l:none, l:blood_red, l:none)

  call Highlight("LspDiagnosticsVirtualTextError", l:danger, l:none, l:none)
  call Highlight("LspDiagnosticsVirtualTextWarning", l:orange, l:none, l:none)
  call Highlight("LspDiagnosticsVirtualTextInformation", l:light_blue, l:none, l:none)
  call Highlight("LspDiagnosticsVirtualTextHint", l:bright_blue, l:none, l:none)

  call Highlight("LspDiagnosticsError", l:none, l:danger, l:bold)
  call Highlight("LspDiagnosticsWarning", l:none, l:orange, l:bold)
  call Highlight("LspDiagnosticsInformation", l:none, l:light_blue, l:bold)
  call Highlight("LspDiagnosticsHint", l:none, l:bright_blue, l:bold)

  " jsx-pretty-config
  " dark red
  hi tsxTagName guifg=#E06C75
  hi tsxComponentName guifg=#E06C75
  hi tsxCloseComponentName guifg=#E06C75

  " orange
  hi tsxCloseString guifg=#F99575
  hi tsxCloseTag guifg=#F99575
  hi tsxCloseTagName guifg=#F99575
  hi tsxAttributeBraces guifg=#F99575
  hi tsxEqual guifg=#F99575

  " yellow
  hi tsxAttrib guifg=#F8BD7F cterm=italic
  " light-grey
  hi tsxTypeBraces guifg=#999999
  " dark-grey
  hi tsxTypes guifg=#666666
  hi ReactState guifg=#C176A7
  hi ReactProps guifg=#D19A66
  hi ApolloGraphQL guifg=#CB886B
  hi Events ctermfg=204 guifg=#56B6Cs
  hi ReduxKeywords ctermfg=204 guifg=#C678DD
  hi ReduxHooksKeywords ctermfg=204 guifg=#C176A7
  hi WebBrowser ctermfg=204 guifg=#56B6C2
  hi ReactLifeCycleMethods ctermfg=204 guifg=#D19A66
endfunction

call CustomTheme()

"@vim-script-end
]], false)
