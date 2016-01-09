let s:config = vivacious#bundleconfig#new()

function! s:config.disable_if()
    return g:VIMRC.is_win || !has('unix')
endfunction
