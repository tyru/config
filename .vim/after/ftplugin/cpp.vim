" vim:foldmethod=marker:fen:
scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim



nnoremap <buffer> [[ [m
nnoremap <buffer> [] [M
nnoremap <buffer> ]] ]m
nnoremap <buffer> ][ ]M



let &cpo = s:save_cpo
