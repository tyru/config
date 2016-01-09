" vim:foldmethod=marker:fen:
scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

setlocal expandtab
let b:undo_ftplugin = 'setlocal expandtab<'

let &cpo = s:save_cpo
