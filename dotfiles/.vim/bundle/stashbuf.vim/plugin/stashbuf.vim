" vim:foldmethod=marker:fen:
scriptencoding utf-8

" Load Once {{{
if exists('g:loaded_stashbuf') && g:loaded_stashbuf
    finish
endif
let g:loaded_stashbuf = 1
" }}}
" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}


if !exists('g:stashbuf_no_default_commands')
    let g:stashbuf_no_default_commands = 0
endif



if !g:stashbuf_no_default_commands
    command!
    \   -bar
    \   StashbufStart
    \   call stashbuf#start()
endif


" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
" }}}
