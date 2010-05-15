" A ref source for jsref
" Version: 0.2.0
" Author : walf443 <walf443 at gmail.com>
" License: Creative Commons Attribution 2.1 Japan License
"          <http://creativecommons.org/licenses/by/2.1/jp/deed.en>

let s:save_cpo = &cpo
set cpo&vim

if !exists('g:ref_jsref_cmd')
    " let g:ref_jsref_cmd = executable("jsref") ? 'jsref' : ''
    let g:ref_jsref_cmd = 'jsref'
endif

let s:source = {'name': 'jsref'}

function! s:source.available()
    return !empty(g:ref_jsref_cmd)
endfunction

function! s:source.get_body(query)
    let res =  ref#system("jsref " . a:query).stdout
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
    if exists('b:current_syntax') && b:current_syntax == 'ref-jsref'
        return
    endif
    syntax clear
    unlet! b:current_syntax

    syntax include @refJs syntax/javascript.vim
    syntax region jsHereDoc    matchgroup=jsStringStartEnd start=+\n\(var\s\)\@=+ end=+^$+ contains=@refJs
    syntax region jsHereDoc    matchgroup=jsStringStartEnd start=+^\(.*\s=\s\)\@=+ end=+^$+ contains=@refJs

    syntax region jsrefKeyword  matchgroup=jsrefKeyword start=+^\(Summary$\|Syntax$\|Parameters$\|Description$\|Properties$\|Methods$\|Examples$\|See\sAlso$\)\@=+ end=+$+
    highlight def link jsrefKeyword Title

    let b:current_syntax = 'ref-jsref'
endfunction

function! ref#jsref#define()
    return s:source
endfunction

call ref#register_detection('js', 'jsref')

let &cpo = s:save_cpo
unlet s:save_cpo

