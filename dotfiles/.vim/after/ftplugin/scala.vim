" vim:foldmethod=marker:fen:
scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim


let s:opt = tyru#util#undo_ftplugin_helper#new()

runtime! ftplugin/java.vim
runtime! compiler/java.vim

call s:opt.set('includeexpr', 'substitute(v:fname,"\\.","/","g")')
call s:opt.set('suffixesadd', '.scala')
call s:opt.append('suffixes', '.class')
call s:opt.restore_option('comments')
setlocal comments& comments^=s1:/*,mb:*,ex:*/,://
call s:opt.set('commentstring', '//%s')
call s:opt.restore_option('formatoptions')
setlocal formatoptions-=t formatoptions+=croql
call s:opt.set('makeprg', '')

let b:undo_ftplugin = s:opt.make_undo_ftplugin()


let &cpo = s:save_cpo
