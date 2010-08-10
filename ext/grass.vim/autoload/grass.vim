" vim:foldmethod=marker:fen:
scriptencoding utf-8

" Load Once {{{
if exists('s:loaded') && s:loaded
    finish
endif
let s:loaded = 1
" }}}
" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}


" Interface {{{

function! grass#run() "{{{
    call s:wwwww.run()
endfunction "}}}

" }}}

" Implementation {{{
let s:wwwww = {'stack': {}}

function! s:wwwww.run() "{{{
    call self.initialize()
    call self.execute()
endfunction "}}}

function! s:wwwww.initialize() "{{{
    " TODO Initiaze with `Premitive`.
endfunction "}}}

function! s:wwwww.execute() "{{{
    let source = join(getline(1, '$'), "\n")

    " TODO
endfunction "}}}

lockvar s:wwwww
" }}}

" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
" }}}
