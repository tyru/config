let s:config = vivo#plugconf#new()

function! s:config.config()
    function! s:stop_hier_on_quickfix_close()
        if !exists(':HierStop')
            return
        endif
        let winnr = winnr()
        windo HierStop
        execute winnr 'wincmd w'
    endfunction

    function! s:start_hier_on_quickfix_open()
        if !exists(':HierStart')
            return
        endif
        let winnr = winnr()
        windo HierStart
        execute winnr 'wincmd w'
    endfunction

    augroup vimrc-hier
        autocmd BufWinLeave *
        \   if &buftype ==# 'quickfix'               |
        \       call s:stop_hier_on_quickfix_close() |
        \   endif
        autocmd BufWinEnter *
        \   if &buftype ==# 'quickfix'               |
        \       call s:start_hier_on_quickfix_open() |
        \   endif
    augroup END
endfunction
