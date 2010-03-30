" vim:foldmethod=marker:fen:
scriptencoding utf-8

" Load Once {{{
if exists('g:loaded_vim_ftplugin') && g:loaded_vim_ftplugin
    finish
endif

if exists("b:did_ftplugin")
    finish
endif
let b:did_ftplugin = 1
" }}}
" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}


let b:match_words = &matchpairs . ',\<if\>:\<en\%[dif]\>'
let b:match_words += ',\<fu\%[nction]!\=\>:\<endf\%[unction]\>'
let b:match_words += ',\<wh\%[ile]\>:\<endwh\%[ile]\>'
let b:match_words += ',\<for\>:\<endfor\=\>'


function! s:set_options()
    " autoload function
    setlocal iskeyword+=#
    setlocal comments=:",:\
endfunction


augroup myftplugin-vim
    autocmd!
    autocmd BufEnter * call s:set_options()
augroup END



" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
" }}}
