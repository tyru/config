" vim:foldmethod=marker:fen:
scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

" Load Once
if exists('g:loaded_code_ftplugin') && g:loaded_code_ftplugin
    finish
endif
" This is optional ftplugin. not "major-mode" :)
" if exists("b:did_ftplugin")
"     finish
" endif
" let b:did_ftplugin = 1




let s:opt = tyru#util#undo_ftplugin_helper#new()


call s:opt.set('textwidth', "80")
call s:opt.set('colorcolumn', "+1")


let b:undo_ftplugin = s:opt.make_undo_ftplugin()




let &cpo = s:save_cpo
