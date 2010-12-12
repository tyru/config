" vim:foldmethod=marker:fen:
scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim


" Do not search from header
setlocal complete-=i
setlocal complete-=d


nnoremap <buffer> [[ [m
nnoremap <buffer> [] [M
nnoremap <buffer> ]] ]m
nnoremap <buffer> ][ ]M


set path+=/usr/local/include

" set path+=/usr/include/c++/*
let s:_ = tyru#util#glob('/usr/include/c++/*')
if !empty(s:_)
    let &path .= ',' . s:_[-1]    " Include only the latest version.
endif
unlet s:_



let &cpo = s:save_cpo
