" vim:foldmethod=marker:fen:
scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

" Do not search from header
setlocal complete-=i
setlocal complete-=d

if isdirectory('/usr/local/include')
    setlocal path^=/usr/local/include
endif
if isdirectory('/usr/include/c++/')
    " Include only the latest version in '/usr/include/c++/'.
    let s:latest = get(glob('/usr/include/c++/*', 1, 1), -1, '')
    if s:latest !=# ''
        let &path .= ',' . s:latest[-1]
    endif
    unlet s:latest
endif

setlocal foldmethod=syntax
let g:c_no_curly_error_fold = 1
let g:c_no_comment_fold = 1

setlocal dictionary=$MYVIMDIR/dict/c.dict

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' | '
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= 'setlocal complete< foldmethod< dictionary<'

let &cpo = s:save_cpo
