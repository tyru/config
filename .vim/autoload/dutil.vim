" vim:foldmethod=marker:fen:
scriptencoding utf-8

" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}



function! dutil#load()
    " dummy
endfunction



" Debug macros


" NOTE: Do not make this function.
" Evaluate arguments at same scope.

" :Dump {{{1
command!
\   -bang -nargs=+ -complete=expression
\   Dump
\
\   echohl Debug
\   | redraw
\   | echomsg printf("  %s = %s", <q-args>, string(<args>))
\   | if <bang>0
\   |   try
\   |     throw ''
\   |   catch
\   |     ShowStackTrace
\   |   endtry
\   | endif
\   | echohl None


" :ShowStackTrace {{{1
command!
\   -bar -bang
\   ShowStackTrace
\
\   echohl WarningMsg
\   | if <bang>0
\   |   echom printf('[%s] at [%s]', v:exception, v:throwpoint)
\   | else
\   |   echom printf('[%s]', v:throwpoint)
\   | endif
\   | echohl None


" :Assert {{{1
command!
\   -nargs=+
\   Assert
\
\   if !eval(<q-args>)
\   |   throw dutil#assertion_failure(<q-args>)
\   | endif

function! dutil#assertion_failure(msg)
    return 'assertion failure: ' . a:msg
endfunction


" :Decho "{{{1
command!
\   -nargs=+
\   Decho
\
\   echohl Debug
\   | echomsg <args>
\   | echohl None

" :Eecho {{{1
command!
\   -nargs=+
\   Eecho
\
\   echohl ErrorMsg
\   | echomsg <args>
\   | echohl None



" :Memo {{{1
command!
\   -nargs=+ -complete=command
\   Memo
\   call s:cmd_memo(<q-args>)

function! s:cmd_memo(args)
    redir => output
    silent execute a:args
    redir END

    echohl Debug
    for line in split(output, '\n')
        echomsg line
    endfor
    echohl None
endfunction




" End.
" }}}1




" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
" }}}
