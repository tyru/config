" vim:foldmethod=marker:fen:
scriptencoding utf-8

" Document {{{
"==================================================
" Name: <% eval: expand('%:t:r') %>
" Version: 0.0.0
" Author:  tyru <tyru.exe+vim@gmail.com>
" Last Change: 2009-07-12.
"
" Change Log: {{{
" }}}
"
" Usage:
"   Commands:
"
"   Mappings:
"
"   Global Variables:
"
"
"
"==================================================
" }}}

" Load Once {{{
if exists('g:loaded_<%filename_noext%>') && g:loaded_<%filename_noext%> != 0
    finish
endif
let g:loaded_<%filename_noext%> = 1
" }}}
" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}

" Scope Variables {{{
" }}}
" Global Variables {{{
" }}}

" Functions {{{

" s:warn {{{
func! s:warn(msg)
    echohl WarningMsg
    echo a:msg
    echohl None
endfunc
" }}}

" }}}
" Commands {{{
" }}}
" Mappings {{{
" }}}
" Autocmd {{{
" }}}

" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
" }}}
