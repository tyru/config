" vim:foldmethod=marker:fen:
scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim


let s:opt = tyru#util#undo_ftplugin_helper#new()

" for javadoc
call s:opt.append('iskeyword', '@-@')
call s:opt.set('makeprg', 'javac %')

let b:undo_ftplugin = s:opt.make_undo_ftplugin()


let &cpo = s:save_cpo
