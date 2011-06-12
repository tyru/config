" vim:foldmethod=marker:fen:
scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


let s:opt = tyru#util#undo_ftplugin_helper#new()

call s:opt.set('tabstop', 2)
call s:opt.set('shiftwidth', 2)

let b:undo_ftplugin = s:opt.make_undo_ftplugin()


let &cpo = s:save_cpo
