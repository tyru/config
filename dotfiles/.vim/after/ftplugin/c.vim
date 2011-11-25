" vim:foldmethod=marker:fen:
scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim


if globpath(&rtp, 'autoload/tyru/util.vim') == ''
    finish
endif

let s:opt = tyru#util#undo_ftplugin_helper#new()

" Do not search from header
call s:opt.restore_option('complete')
setlocal complete-=i
setlocal complete-=d


call s:opt.append('path', '/usr/local/include')

" set path+=/usr/include/c++/*
let s:_ = tyru#util#glob('/usr/include/c++/*')
if !empty(s:_)
    let &path .= ',' . s:_[-1]    " Include only the latest version.
endif
unlet s:_


call s:opt.set('foldmethod', 'syntax')
call s:opt.let('g:c_no_curly_error_fold', 1)
call s:opt.let('g:c_no_comment_fold', 1)

let b:undo_ftplugin = s:opt.make_undo_ftplugin()


let &cpo = s:save_cpo
