let s:config = BundleConfigGet()

function! s:config.config()
    set ballooneval
    set balloonexpr=foldballoon#balloonexpr()
endfunction
