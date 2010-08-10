" vim:foldmethod=marker:fen:
scriptencoding utf-8

" Load Once {{{
if exists('g:loaded_grass') && g:loaded_grass
    finish
endif
let g:loaded_grass = 1
" }}}
" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}



command!
\   -bar
\   Grass
\   call grass#run()


" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
" }}}
