" vim:foldmethod=marker:fen:
scriptencoding utf-8

" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}


function! <%eval:substitute(expand("%:t:r"), "\\m\\W", "_", "g")%>#load()
    " dummy function to load this script.
endfunction


" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
" }}}
