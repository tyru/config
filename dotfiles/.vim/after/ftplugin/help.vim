" vim:foldmethod=marker:fen:
scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

" https://github.com/vim-jp/vimdoc-ja-working/issues/54
set formatexpr=autofmt#japanese#formatexpr()
let g:autofmt_allow_over_tw = 1

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' | '
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= 'setlocal formatexpr<'

let &cpo = s:save_cpo
