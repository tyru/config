scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


let s:textobjentire = vivo#plugconf#new()

" Configuration for textobj-entire.
function! s:textobjentire.config()
    let g:textobj_entire_no_default_key_mappings = 1
    xmap i@ <Plug>(textobj-entire-i)
    omap i@ <Plug>(textobj-entire-i)
    xmap a@ <Plug>(textobj-entire-a)
    omap a@ <Plug>(textobj-entire-a)
endfunction

" Plugin dependencies for textobj-entire.
function! s:textobjentire.depends()
    return []
endfunction

" Recommended plugin dependencies for textobj-entire.
" If the plugins are not installed, vivo shows recommended plugins.
function! s:textobjentire.recommends()
    return []
endfunction

" External commands dependencies for textobj-entire.
" (e.g.: curl)
function! s:textobjentire.depends_commands()
    return []
endfunction

" Recommended external commands dependencies for textobj-entire.
" If the plugins are not installed, vivo shows recommended commands.
function! s:textobjentire.recommends_commands()
    return []
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
