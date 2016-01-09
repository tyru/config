" vim:foldmethod=marker:fen:
scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

" http://vim.wikia.com/wiki/Omnicomplete_-_Remove_Python_Pydoc_Preview_Window
setlocal completeopt-=preview

let b:undo_ftplugin = 'setlocal completeopt<'

let &cpo = s:save_cpo
