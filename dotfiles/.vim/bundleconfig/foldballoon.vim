let s:config = vivo#bundleconfig#new()

function! s:config.config()
    set ballooneval
    set balloonexpr=foldballoon#balloonexpr()
endfunction
