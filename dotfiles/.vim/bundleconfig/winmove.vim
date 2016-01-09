let s:config = vivacious#bundleconfig#new()

function! s:config.config()
    let g:wm_move_down  = '<C-M-j>'
    let g:wm_move_up    = '<C-M-k>'
    let g:wm_move_left  = '<C-M-h>'
    let g:wm_move_right = '<C-M-l>'
endfunction
