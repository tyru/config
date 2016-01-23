scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


let s:trailingwhitespace = vivacious#bundleconfig#new()

" Configuration for trailing-whitespace.
function! s:trailingwhitespace.config()
    " TODO:
    " * Clear highlight temporarily (':hi clear ExtraWhitespace' is enough?)
    " * Overwrite default highlight defined by trailing-whitespace.vim properly.
    let hicmd = 'highlight ExtraWhitespace cterm=underline ctermfg=4 gui=underline guifg=Cyan'
    execute hicmd
    execute 'autocmd ColorScheme *' hicmd
endfunction

" Plugin dependencies for trailing-whitespace.
function! s:trailingwhitespace.depends()
    return []
endfunction

" Recommended plugin dependencies for trailing-whitespace.
" If the plugins are not installed, vivacious shows recommended plugins.
function! s:trailingwhitespace.recommends()
    return []
endfunction

" External commands dependencies for trailing-whitespace.
" (e.g.: curl)
function! s:trailingwhitespace.depends_commands()
    return []
endfunction

" Recommended external commands dependencies for trailing-whitespace.
" If the plugins are not installed, vivacious shows recommended commands.
function! s:trailingwhitespace.recommends_commands()
    return []
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
