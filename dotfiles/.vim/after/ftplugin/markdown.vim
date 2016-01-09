" vim:foldmethod=marker:fen:
scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

setlocal tabstop=2 shiftwidth=0
let b:undo_ftplugin = 'setlocal tabstop< shiftwidth<'

let &cpo = s:save_cpo
