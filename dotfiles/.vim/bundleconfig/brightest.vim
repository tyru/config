let s:config = vivo#bundleconfig#new()

function! s:config.config()
    let g:brightest#enable_on_CursorHold = 1
    let g:brightest#enable_filetypes = {
    \   '_': 0,
    \   'c': 1,
    \   'cpp': 1,
    \   'css': 1,
    \   'go': 1,
    \   'html': 1,
    \   'javascript': 1,
    \   'vim': 1,
    \}
endfunction
