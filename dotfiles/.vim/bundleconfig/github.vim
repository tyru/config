let s:config = vivo#bundleconfig#new()

function! s:config.config()
    MapAlterCommand gh Github
    MapAlterCommand ghi Github issues
endfunction
