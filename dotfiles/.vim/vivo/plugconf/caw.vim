scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


let s:caw = vivo#plugconf#new()

" Configuration for caw.
function! s:caw.config()
    nmap <Leader>c <Plug>(caw:i:toggle)
endfunction

" Plugin dependencies for caw.
function! s:caw.depends()
    return []
endfunction

" Recommended plugin dependencies for caw.
" If the plugins are not installed, vivo shows recommended plugins.
function! s:caw.recommends()
    return []
endfunction

" External commands dependencies for caw.
" (e.g.: curl)
function! s:caw.depends_commands()
    return []
endfunction

" Recommended external commands dependencies for caw.
" If the plugins are not installed, vivo shows recommended commands.
function! s:caw.recommends_commands()
    return []
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
