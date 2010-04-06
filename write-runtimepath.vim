" vim:foldmethod=marker:fen:
scriptencoding utf-8

" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}

function! s:cmd_die(...)
    echohl ErrorMsg
    echomsg join(a:000)
    echohl None
    qall!
endfunction

command!
\   -nargs=+
\   Die
\   call s:cmd_die(<args>)

function! s:run()
    if argc() != 1
        Die "Specify filename to write runtimepath."
    endif
    let file = argv(0)

    " Create file.
    if writefile(sort(split(&rtp, ',')), file) == -1
        Die printf("Failed to write to '%s'.", file)
    endif
endfunction
call s:run()

quit

" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
" }}}
