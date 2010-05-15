" A ref source for cppref
" Version: 0.2.0
" Author : walf443 <walf443 at gmail.com>
" License: Creative Commons Attribution 2.1 Japan License
"          <http://creativecommons.org/licenses/by/2.1/jp/deed.en>

let s:save_cpo = &cpo
set cpo&vim

if !exists('g:ref_cppref_cmd')
    " let g:ref_cppref_cmd = executable("cppref") ? 'cppref' : ''
    let g:ref_cppref_cmd = 'cppref'
endif

let s:source = {'name': 'cppref'}

function! s:source.available()
    return !empty(g:ref_cppref_cmd)
endfunction

function! s:source.get_body(query)
    let res =  ref#system("cppref " . a:query).stdout
    return s:filter(res)
endfunction

function! s:filter(body)
    " 目次に遭遇したときにjumpできるように置換してやる
    "  ex.) ● std >> deqeue >> push_back
    "   ->  -  std >> deqeue::push_back
    let res = substitute(a:body, "• \\([^\n]*\\) >> ", "- \\1::", "g")

    return res
endfunction

function! s:source.opened(query)
    call s:syntax(a:query)
endfunction

function! s:source.leave()
    syntax clear
endfunction

function! s:source.get_keyword()
    let isk = &l:iskeyword
    setlocal isk& isk+=:
    let kwd = expand('<cword>')
    if exists("b:ref_history_pos")
        if match(kwd, "::") == -1
            let buf_name = b:ref_history[b:ref_history_pos][1]
            if match(buf_name, "stl::\\(.\\+\\)") == -1 " stl::vectorみたいなのだけうまくいかないので特別扱い
                let base_class = substitute(buf_name, "^\\([^:]\\+\\)::\\(.*\\)", "\\1", "")
            else
                let base_class = substitute(buf_name, "stl::\\(.\\+\\)", "\\1", "")
            endif
            if base_class != ""
                let kwd = base_class . "::" . kwd
            endif
        endif
    endif
    let &l:iskeyword = isk
    return kwd
endfunction

function! s:syntax(query)
    if exists('b:current_syntax') && b:current_syntax == 'ref-cppref'
        return
    endif
    syntax clear
    unlet! b:current_syntax

    syntax include @refCpp syntax/cpp.vim
    syntax region cppHereDoc    matchgroup=cppStringStartEnd start=+^\s\s\s+ end=+$+ contains=@refCpp

    let b:current_syntax = 'ref-cppref'
endfunction

function! ref#cppref#define()
    return s:source
endfunction

call ref#register_detection('cpp', 'cppref')

let &cpo = s:save_cpo
unlet s:save_cpo


