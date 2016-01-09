let s:config = vivacious#bundleconfig#new()

function! s:config.config()
    MapAlterCommand pp PP

    let g:prettyprint_show_expression = 1
endfunction
