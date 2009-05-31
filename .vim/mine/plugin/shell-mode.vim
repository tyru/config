" vim:foldmethod=marker:fen:
scriptencoding utf-8

" DOCUMENT {{{1
"==================================================
" Name: shell-mode
" Version: 0.0.0
" Author:  tyru <tyru.exe@gmail.com>
" Last Change: 2009-05-31.
"
" Change Log: {{{2
"   0.0.0: Initial upload.
" }}}2
"
" Usage:
"   COMMANDS:
"
"   MAPPING:
"
"   GLOBAL VARIABLES:
"
"
"
"==================================================
" }}}1

" INCLUDE GUARD {{{1
if exists('g:loaded_shell-mode') && g:loaded_shell-mode != 0 | finish | endif
let g:loaded_shell-mode = 1
" }}}1
" SAVING CPO {{{1
let s:save_cpo = &cpo
set cpo&vim
" }}}1

" SCOPED VARIABLES {{{1
" }}}1
" GLOBAL VARIABLES {{{1
" }}}1

" FUNCTION DEFINITION {{{1

" s:warn(msg) {{{2
func! s:warn(msg)
    echohl WarningMsg
    echo a:msg
    echohl None
endfunc
" }}}2

" }}}1

" COMMAND {{{1
" }}}1

" MAPPING {{{1
" }}}1

" AUTOCOMMAND {{{1
" }}}1

" RESTORE CPO {{{1
let &cpo = s:save_cpo
" }}}1

