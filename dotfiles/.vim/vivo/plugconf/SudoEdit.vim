let s:config = vivo#plugconf#new()

function! s:config.disable_if()
    let is_win = has('win16') || has('win32') || has('win64') || has('win95')
    let is_unix_terminal = !is_win && has('unix') && !has('gui_running')
    return !is_unix_terminal
endfunction
