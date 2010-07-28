" vim:foldmethod=marker:fen:
scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim


" TODO: Do not re-indent when comment inserted.

setlocal noexpandtab
setlocal comments+=b:#

inoremap <buffer> <CR> X<BS><CR>
inoremap <buffer> <Esc> X<BS><Esc>


let &cpo = s:save_cpo
