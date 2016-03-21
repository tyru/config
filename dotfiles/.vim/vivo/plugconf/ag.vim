let s:config = vivo#plugconf#new()

function! s:config.depends_commands()
    return 'ag'
endfunction

function! s:config.config()
    let g:ag_apply_lmappings = 0

    MapAlterCommand ag Ag
    MapAlterCommand agf[ile] AgFile
    MapAlterCommand lag LAg
endfunction
