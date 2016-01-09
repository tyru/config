let s:config = vivacious#bundleconfig#new()

function! s:config.config()
    set foldtext=FoldCCtext()
endfunction
