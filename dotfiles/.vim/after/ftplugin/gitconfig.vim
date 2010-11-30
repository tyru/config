" vim:foldmethod=marker:fen:
scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


let b:undo_ftplugin = 'let &et = '.string(&et)
setlocal noet


let &cpo = s:save_cpo
