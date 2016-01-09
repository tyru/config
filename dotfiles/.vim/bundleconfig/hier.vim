let s:config = vivacious#bundleconfig#new()

function! s:config.config()
    function! s:stop_hier_on_quickfix_close()
        if !exists(':HierStop')
            return
        endif
        if !s:quickfix_exists_window()
            let winnr = winnr()
            windo HierStop
            execute winnr 'wincmd w'
        endif
    endfunction
    function! s:start_hier_on_quickfix_open()
        if !exists(':HierStart')
            return
        endif
        if s:quickfix_exists_window()
            let winnr = winnr()
            windo HierStart
            execute winnr 'wincmd w'
        endif
    endfunction
    autocmd vimrc WinEnter *
    \   call s:stop_hier_on_quickfix_close()
    autocmd vimrc QuickFixCmdPost *
    \   call s:start_hier_on_quickfix_open()
    autocmd vimrc WinEnter *
    \     if &filetype ==# 'qf'
    \   |   call s:start_hier_on_quickfix_open()
    \   | endif
endfunction

function! s:quickfix_get_winnr()
    " quickfix window is usually at bottom,
    " thus reverse-lookup.
    for winnr in reverse(range(1, winnr('$')))
        if getwinvar(winnr, '&buftype') ==# 'quickfix'
            return winnr
        endif
    endfor
    return 0
endfunction

function! s:quickfix_exists_window()
    return !!s:quickfix_get_winnr()
endfunction
