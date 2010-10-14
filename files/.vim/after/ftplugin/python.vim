" vim:foldmethod=marker:fen:
scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim


" TODO: Do not re-indent when comment inserted.
setlocal comments+=b:#


let &cpo = s:save_cpo
