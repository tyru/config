let s:config = vivacious#bundleconfig#new()

function! s:config.config()
    let g:EasyGrepCommand = 2
    let g:EasyGrepInvertWholeWord = 1
endfunction
