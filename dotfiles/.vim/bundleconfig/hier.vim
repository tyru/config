let s:config = BundleConfigGet()

function! s:config.config()
    function! s:stop_hier_on_quickfix_close()
        if !exists(':HierStop')
            return
        endif
        if !g:VIMRC.quickfix_exists_window()
            let winnr = winnr()
            windo HierStop
            execute winnr 'wincmd w'
        endif
    endfunction
    function! s:start_hier_on_quickfix_open()
        if !exists(':HierStart')
            return
        endif
        if g:VIMRC.quickfix_exists_window()
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
