" vim:foldmethod=marker:fen:
scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim


" for javadoc
setlocal iskeyword+=@-@
setlocal makeprg=javac\ %


let &cpo = s:save_cpo
