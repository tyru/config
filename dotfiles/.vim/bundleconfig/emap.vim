let s:config = vivacious#bundleconfig#new()

function! s:config.config()
    MapAlterCommand map Map
    MapAlterCommand amp Map
    MapAlterCommand mpa Map
endfunction
