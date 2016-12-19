scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


let s:quickey = vivo#plugconf#new()

" Configuration for quickey.
function! s:quickey.config()
    let g:quickey_no_default_tabwinmerge_keymappings = 1
    let g:quickey_no_default_swap_window_keymappings = 1
    let g:quickey_no_default_merge_window_keymappings = 1
endfunction

" Plugin dependencies for quickey.
function! s:quickey.depends()
    return []
endfunction

" Recommended plugin dependencies for quickey.
" If the plugins are not installed, vivo shows recommended plugins.
function! s:quickey.recommends()
    return []
endfunction

" External commands dependencies for quickey.
" (e.g.: curl)
function! s:quickey.depends_commands()
    return []
endfunction

" Recommended external commands dependencies for quickey.
" If the plugins are not installed, vivo shows recommended commands.
function! s:quickey.recommends_commands()
    return []
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
