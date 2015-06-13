let s:config = BundleConfigGet()

function! s:config.disable_if()
    return !g:VIMRC.is_unix_terminal
endfunction
