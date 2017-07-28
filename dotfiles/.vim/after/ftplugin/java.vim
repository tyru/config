" vim:foldmethod=marker:fen:
scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

" for javadoc
setlocal iskeyword+=@-@
setlocal makeprg=javac\ %
setlocal dictionary=$MYVIMDIR/dict/java.dict

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' | '
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= 'setlocal iskeyword< makeprg< dictionary<'

let &cpo = s:save_cpo
