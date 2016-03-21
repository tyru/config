let s:config = vivo#plugconf#new()

function! s:config.config()
    set ballooneval
    set balloonexpr=foldballoon#balloonexpr()
endfunction
