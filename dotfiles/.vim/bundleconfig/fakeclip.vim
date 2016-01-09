let s:config = vivacious#bundleconfig#new()

function! s:config.disable_if()
    let is_win = has('win16') || has('win32') || has('win64') || has('win95')
    let is_unix_terminal = !is_win && has('unix') && !has('gui_running')
    return !is_unix_terminal
endfunction

function! s:config.config()
    " vim-fakeclip plugin is loaded only on the platform where
    " 1. the X server exists
    " 2. starting Vim of non-GUI version
    set clipboard+=exclude:.*
    let g:fakeclip_always_provide_clipboard_mappings = 1
endfunction
