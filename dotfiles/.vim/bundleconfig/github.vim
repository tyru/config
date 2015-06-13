let s:config = BundleConfigGet()

function! s:config.config()
    MapAlterCommand gh Github
    MapAlterCommand ghi Github issues
endfunction
