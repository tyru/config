" vim:foldmethod=marker:fen:
scriptencoding utf-8

" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}


setlocal noexpandtab
inoremap <buffer> <CR> X<BS><CR>
inoremap <buffer> <Esc> X<BS><Esc>

" TODO: Do not re-indent when comment inserted.


" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
" }}}
