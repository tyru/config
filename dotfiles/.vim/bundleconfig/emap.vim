let s:config = BundleConfigGet()

function! s:config.config()
    MapAlterCommand map Map
    MapAlterCommand amp Map
    MapAlterCommand mpa Map
endfunction
