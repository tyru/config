let s:config = vivo#plugconf#new()

function! s:config.config()
    MapAlterCommand map Map
    MapAlterCommand amp Map
    MapAlterCommand mpa Map
endfunction
