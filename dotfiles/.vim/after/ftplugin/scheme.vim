" vim:foldmethod=marker:fen:
scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim


call s:opt = tyru#util#undo_ftplugin_helper#new()

call s:opt.set('lisp')
call s:opt.unset('cindent')
call s:opt.set('complete', '.,t,k,kspell')

let b:undo_ftplugin = s:opt.make_undo_ftplugin()


let &cpo = s:save_cpo
