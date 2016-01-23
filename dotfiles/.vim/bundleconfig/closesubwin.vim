scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


let s:closesubwin = vivacious#bundleconfig#new()

" Configuration for closesubwin.
function! s:closesubwin.config()
    Map -remap [n] <excmd>ch <Plug>(closesubwin-close-help)
    Map -remap [n] <excmd>cq <Plug>(closesubwin-close-quickfix)
    Map -remap [n] <excmd>cu <Plug>(closesubwin-close-unlisted)
    " Close first matching window in above windows.
    Map -remap [n] <excmd>cc <Plug>(closesubwin-close-sub)
endfunction

" Plugin dependencies for closesubwin.
function! s:closesubwin.depends()
    return []
endfunction

" Recommended plugin dependencies for closesubwin.
" If the plugins are not installed, vivacious shows recommended plugins.
function! s:closesubwin.recommends()
    return []
endfunction

" External commands dependencies for closesubwin.
" (e.g.: curl)
function! s:closesubwin.depends_commands()
    return []
endfunction

" Recommended external commands dependencies for closesubwin.
" If the plugins are not installed, vivacious shows recommended commands.
function! s:closesubwin.recommends_commands()
    return []
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
