scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


let s:gista = vivacious#bundleconfig#new()

" Configuration for gista.
function! s:gista.config()
    let g:gista#command#post#open_browser = 1
endfunction

" Plugin dependencies for gista.
function! s:gista.depends()
    return []
endfunction

" Recommended plugin dependencies for gista.
" If the plugins are not installed, vivacious shows recommended plugins.
function! s:gista.recommends()
    return []
endfunction

" External commands dependencies for gista.
" (e.g.: curl)
function! s:gista.depends_commands()
    return []
endfunction

" Recommended external commands dependencies for gista.
" If the plugins are not installed, vivacious shows recommended commands.
function! s:gista.recommends_commands()
    return []
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
