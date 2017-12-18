" vim:foldmethod=marker:fen:
scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

setlocal includeexpr=substitute(v:fname,'^\\/','','')
setlocal path+=;/
setlocal dictionary=$MYVIMDIR/dict/html.dict,$MYVIMDIR/dict/javascript.dict

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' | '
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= 'setlocal includeexpr< path< dictionary<'

let &cpo = s:save_cpo
