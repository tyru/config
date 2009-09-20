" vim:foldmethod=marker:fen:
scriptencoding utf-8

" Load Once
if exists('g:loaded_test') && g:loaded_test != 0
    finish
endif
let g:loaded_test = 1

" Saving 'cpoptions'
let s:save_cpo = &cpo
set cpo&vim


" s:foo {{{
func! s:foo()
endfunc
" }}}



" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
" }}}
