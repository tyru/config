" vim:foldmethod=marker:fen:
scriptencoding utf-8

" Load Once {{{
if exists('g:loaded_emo') && g:loaded_emo
    finish
endif
let g:loaded_emo = 1
" }}}
" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}


" Commands {{{
command!
\   -bar
\   Emo
\   echo
" }}}

" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
" }}}
