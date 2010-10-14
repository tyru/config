" vim:foldmethod=marker:fen:
scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

" Load Once {{{
if exists('g:loaded_<%eval:substitute(expand("%:t:r"), "\\m\\W", "_", "g")%>_ftplugin') && g:loaded_<%eval:substitute(expand("%:t:r"), "\\m\\W", "_", "g")%>_ftplugin
    finish
endif

if exists("b:did_ftplugin")
    finish
endif
let b:did_ftplugin = 1
" }}}







let &cpo = s:save_cpo
