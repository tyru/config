" vim:foldmethod=marker:fen:
scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim


let b:undo_ftplugin =
\   'let &l:lispwords = '.string(&l:lispwords)
\    . '| let &l:lisp = '.string(&l:lisp)
\    . '| let &l:cindent = '.string(&l:cindent)
\    . '| let &l:complete = '.string(&l:complete)



setlocal lisp
setlocal nocindent
setlocal complete=.,t,k,kspell



let &cpo = s:save_cpo
