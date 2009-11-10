" vim:foldmethod=marker:fen:
scriptencoding utf-8

" Document {{{
"==================================================
" Name: <% eval: expand('%:t:r') %>
" Version: 0.0.0
" Author:  tyru <tyru.exe@gmail.com>
" Last Change: 2009-11-10.
"
" Description:
"   NO DESCRIPTION YET
"
" Change Log: {{{
" }}}
" Usage: {{{
"   Commands: {{{
"   }}}
"   Mappings: {{{
"   }}}
"   Global Variables: {{{
"   }}}
" }}}
"==================================================
" }}}

" Load Once {{{
if exists('g:loaded_<%eval:substitute(expand("%:t:r"), "\\m\\W", "_", "g")%>') && g:loaded_<%eval:substitute(expand("%:t:r"), "\\m\\W", "_", "g")%>
    finish
endif
let g:loaded_<%eval:substitute(expand("%:t:r"), "\\m\\W", "_", "g")%> = 1
" }}}
" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}

" Scope Variables {{{
let s:debug_errmsg = []
" }}}
" Global Variables {{{
" }}}

" Functions {{{

" Debug {{{
if g:<%eval:substitute(expand("%:t:r"), "\\m\\W", "_", "g")%>_debug
    func! s:debug(cmd, ...)
        if a:cmd ==# 'on'
            let g:<%eval:substitute(expand("%:t:r"), "\\m\\W", "_", "g")%>_debug = 1
        elseif a:cmd ==# 'off'
            let g:<%eval:substitute(expand("%:t:r"), "\\m\\W", "_", "g")%>_debug = 0
        elseif a:cmd ==# 'list'
            for i in s:debug_errmsg
                echo i
            endfor
        elseif a:cmd ==# 'eval'
            redraw
            execute join(a:000, ' ')
        endif
    endfunc

    com! -nargs=+ SDDebug
        \ call s:debug(<f-args>)
endif

" s:debugmsg {{{
func! s:debugmsg(msg)
    if g:<%eval:substitute(expand("%:t:r"), "\\m\\W", "_", "g")%>_debug
        call s:warn(a:msg)
    endif
endfunc
" }}}

" }}}

" s:warn {{{
func! s:warn(msg)
    echohl WarningMsg
    echo msg
    echohl None

    call add(s:debug_errmsg, msg)
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
