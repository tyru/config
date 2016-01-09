let s:config = vivacious#bundleconfig#new()

function! s:config.config()
    if has('vim_starting')
        call watchdogs#setup(g:quickrun_config)
    endif
    let g:watchdogs_check_BufWritePost_enable = 1

    command! WatchdogsStart
    \     let g:watchdogs_check_BufWritePost_enable = 1
    \   | let g:watchdogs_check_CursorHold_enable   = 1
    \   | echo 'enabled watchdogs auto-commands.'
    command! WatchdogsStop
    \     let g:watchdogs_check_BufWritePost_enable = 0
    \   | let g:watchdogs_check_CursorHold_enable   = 0
    \   | echo 'disabled watchdogs auto-commands.'
endfunction
