let s:config = vivo#plugconf#new()

function! s:config.config()
    MapAlterCommand gh Github
    MapAlterCommand ghi Github issues
endfunction
