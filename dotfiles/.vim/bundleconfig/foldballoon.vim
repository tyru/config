let s:config = vivacious#bundleconfig#new()

function! s:config.config()
    set ballooneval
    set balloonexpr=foldballoon#balloonexpr()
endfunction
