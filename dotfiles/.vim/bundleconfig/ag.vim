let s:config = vivo#bundleconfig#new()

function! s:config.depends_commands()
    return 'ag'
endfunction

function! s:config.config()
    MapAlterCommand ag Ag
    MapAlterCommand agf[ile] AgFile
    MapAlterCommand lag LAg
endfunction
