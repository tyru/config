scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


let s:zenspace = vivo#plugconf#new()

" Configuration for zenspace.
function! s:zenspace.config()
    augroup vimrc-zenspace
        autocmd!
        autocmd ColorScheme * if &bg ==# 'dark'
        autocmd ColorScheme *   highlight ZenSpace guifg=White guibg=bg gui=underline
        autocmd ColorScheme * else
        autocmd ColorScheme *   highlight ZenSpace guifg=Blue guibg=bg gui=underline
        autocmd ColorScheme * endif
    augroup END
endfunction

" Plugin dependencies for zenspace.
function! s:zenspace.depends()
    return []
endfunction

" Recommended plugin dependencies for zenspace.
" If the plugins are not installed, vivo shows recommended plugins.
function! s:zenspace.recommends()
    return []
endfunction

" External commands dependencies for zenspace.
" (e.g.: curl)
function! s:zenspace.depends_commands()
    return []
endfunction

" Recommended external commands dependencies for zenspace.
" If the plugins are not installed, vivo shows recommended commands.
function! s:zenspace.recommends_commands()
    return []
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
