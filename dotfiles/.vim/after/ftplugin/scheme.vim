" vim:foldmethod=marker:fen:
scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

setlocal lisp
setlocal nocindent
setlocal complete=.,t,k,kspell

inoremap <buffer> <Tab><Tab> <C-o>mz<C-o>=ip<C-o>'z
nnoremap <buffer> <Tab><Tab> mz=ip'z

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' | '
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= 'setlocal lisp< cindent< complete<'

let &cpo = s:save_cpo
