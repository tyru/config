let s:config = vivo#bundleconfig#new()

function! s:config.disable_if()
    return !exists('$VPROVE_TESTING')
endfunction

function! s:config.config()
    let g:simpletap#open_command = 'botright vnew'
endfunction
