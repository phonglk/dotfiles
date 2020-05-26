let &t_ti.="\e[?7727h"
let &t_te.="\e[?7727l"
set inccommand=nosplit
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
set winblend=10

let $FZF_DEFAULT_OPTS='--layout=reverse'
let g:fzf_layout = { 'window': 'call CreateCenteredFloatingWindow()' }

function! FloatingFZF()
    let buf = nvim_create_buf(v:false, v:true)
    call setbufvar(buf, '&signcolumn', 'no')

    let height = &lines / 2
    let width = float2nr(&columns / 2)
    let col = float2nr((&columns - width) / 2)

    let opts = {
                \ 'relative': 'editor',
                \ 'row': &lines / 4,
                \ 'col': col,
                \ 'width': width,
                \ 'height': height,
                \ 'style': 'minimal'
                \ }

    call nvim_open_win(buf, v:true, opts)
endfunction

function! CreateCenteredFloatingWindow()
    let width = min([&columns - 4, max([80, &columns - 20])])
    let height = min([&lines - 4, max([20, &lines - 10])])
    let top = ((&lines - height) / 2) - 1
    let left = (&columns - width) / 2
    let opts = {'relative': 'editor', 'row': top, 'col': left, 'width': width, 'height': height, 'style': 'minimal'}

    let top = "╭" . repeat("─", width - 2) . "╮"
    let mid = "│" . repeat(" ", width - 2) . "│"
    let bot = "╰" . repeat("─", width - 2) . "╯"
    let lines = [top] + repeat([mid], height - 2) + [bot]
    let s:buf = nvim_create_buf(v:false, v:true)
    call nvim_buf_set_lines(s:buf, 0, -1, v:true, lines)
    call nvim_open_win(s:buf, v:true, opts)
    set winhl=Normal:Floating
    let opts.row += 1
    let opts.height -= 2
    let opts.col += 2
    let opts.width -= 4
    call nvim_open_win(nvim_create_buf(v:false, v:true), v:true, opts)
    au BufWipeout <buffer> exe 'bw '.s:buf
endfunction
