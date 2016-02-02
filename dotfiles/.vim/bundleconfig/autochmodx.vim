let s:config = vivo#bundleconfig#new()

function! s:config.disable_if()
    let is_win = has('win16') || has('win32') || has('win64') || has('win95')
    return is_win || !has('unix')
endfunction
