let s:config = BundleConfigGet()

function! s:config.depends_commands()
    return 'ag'
endfunction

function! s:config.config()
    MapAlterCommand ag Ag
endfunction
