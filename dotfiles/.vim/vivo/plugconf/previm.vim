scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


let s:previm = vivo#plugconf#new()

" Configuration for previm.
function! s:previm.config()
    augroup vimrc-previm
        autocmd!
        autocmd FileType *{mkd,markdown,rst,textile}*
        \       nnoremap <buffer> <LocalLeader>p PrevimOpen
    augroup END
endfunction

" Plugin dependencies for previm.
function! s:previm.depends()
    return []
endfunction

" Recommended plugin dependencies for previm.
" If the plugins are not installed, vivo shows recommended plugins.
function! s:previm.recommends()
    return []
endfunction

" External commands dependencies for previm.
" (e.g.: curl)
function! s:previm.depends_commands()
    return []
endfunction

" Recommended external commands dependencies for previm.
" If the plugins are not installed, vivo shows recommended commands.
function! s:previm.recommends_commands()
    return []
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
