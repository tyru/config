" vim:foldmethod=marker:fen:
scriptencoding utf-8

" Load Once {{{
if exists('g:loaded_ref_perldoc_ftplugin') && g:loaded_ref_perldoc_ftplugin
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

let b:undo_ftplugin = 'unmap <buffer> <LocalLeader>t'

nnoremap <silent><buffer><expr> <LocalLeader>t
\ b:ref_perldoc_mode ==# 'module' ? ":\<C-u>Ref perldoc -m " .
\                                b:ref_perldoc_word . "\<CR>" :
\ b:ref_perldoc_mode ==# 'source' ? ":\<C-u>Ref perldoc " .
\                                b:ref_perldoc_word . "\<CR>" :
\ g:maplocalleader . 't'

" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
" }}}
