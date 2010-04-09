" vim:foldmethod=marker:fen:
scriptencoding utf-8

" NEW BSD LICENSE {{{
"   Copyright (c) 2009, tyru
"   All rights reserved.
"
"   Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
"
"       * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
"       * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
"       * Neither the name of the tyru nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
"
"   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
" }}}
" Change Log: {{{
" }}}
" Document {{{
"
" Name: <% eval: expand('%:t:r') %>
" Version: 0.0.0
" Author:  tyru <tyru.exe@gmail.com>
" Last Change: 2010-04-09.
"
" Description:
"   NO DESCRIPTION YET
"
" Usage: {{{
"   Commands: {{{
"   }}}
"   Mappings: {{{
"   }}}
"   Global Variables: {{{
"   }}}
" }}}
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
if !exists('g:<%eval:substitute(expand("%:t:r"), "\\m\\W", "_", "g")%>_debug')
    let g:<%eval:substitute(expand("%:t:r"), "\\m\\W", "_", "g")%>_debug = 0
endif
" }}}

" Functions {{{

" utility functions
" Debug {{{
if g:<%eval:substitute(expand("%:t:r"), "\\m\\W", "_", "g")%>_debug
    function! s:debug(cmd, ...)
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
    endfunction

    com! -nargs=+ <%filename_camel%>Debug
        \ call s:debug(<f-args>)
endif

" s:debugmsg {{{
function! s:debugmsg(msg)
    if g:<%eval:substitute(expand("%:t:r"), "\\m\\W", "_", "g")%>_debug
        call s:warn(a:msg)
    endif
endfunction
" }}}

" }}}
function! s:warn(msg) "{{{
    echohl WarningMsg
    echomsg a:msg
    echohl None

    call add(s:debug_errmsg, a:msg)
endfunction "}}}
function! s:warnf(...) "{{{
    call s:warn(call('printf', a:000))
endfunction "}}}

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
