" vim:foldmethod=marker:fen:
scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

setlocal iskeyword+=-,+
let b:undo_ftplugin = 'setlocal iskeyword<'

let &cpo = s:save_cpo
