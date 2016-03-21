scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


let s:vimoperatorreplace = vivo#plugconf#new()

" Configuration for vim-operator-replace.
function! s:vimoperatorreplace.config()
    Map -remap [nxo] <operator>r <Plug>(operator-replace)
endfunction

" Plugin dependencies for vim-operator-replace.
function! s:vimoperatorreplace.depends()
    return []
endfunction

" Recommended plugin dependencies for vim-operator-replace.
" If the plugins are not installed, vivo shows recommended plugins.
function! s:vimoperatorreplace.recommends()
    return []
endfunction

" External commands dependencies for vim-operator-replace.
" (e.g.: curl)
function! s:vimoperatorreplace.depends_commands()
    return []
endfunction

" Recommended external commands dependencies for vim-operator-replace.
" If the plugins are not installed, vivo shows recommended commands.
function! s:vimoperatorreplace.recommends_commands()
    return []
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
