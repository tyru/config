" vim:foldmethod=marker:fen:
scriptencoding utf-8

" Document {{{
"==================================================
" Name: workaround-for-vim-bug-cant-restore-col-over-blank-line
" Version: 0.0.0
" Author:  tyru <tyru.exe@gmail.com>
" Last Change: 2009-10-03.
"
" Description:
"   workaround for the bug that Vim can't restore col over the blank line
"
" Change Log: {{{
" }}}
" Usage: {{{
"   Mappings: {{{
"   }}}
" }}}
"==================================================
" }}}

" Load Once {{{
if exists('g:loaded_workaround_for_vim_bug_cant_restore_col_over_blank_line') && g:loaded_workaround_for_vim_bug_cant_restore_col_over_blank_line != 0
    finish
endif
let g:loaded_workaround_for_vim_bug_cant_restore_col_over_blank_line = 1
" }}}
" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}

" Scope Variables {{{
let s:pos = getpos('.')
let s:POS_ZERO = -1
let s:POS_DOLLAR = -2
" }}}

" Functions {{{

" s:warn {{{
func! s:warn(msg)
    echohl WarningMsg
    echo msg
    echohl None
endfunc
" }}}

" XXX
" s:move {{{
func! s:move(map)
    let prev_pos = getpos('.')
    let prev_col = prev_pos[2]

    " move!
    execute 'normal! ' . a:map

    if s:pos[2] < col('$')    " if cursor can go to s:pos[2]
        " set current lnum
        let s:pos[1] = line('.')
        " restore s:pos
        if s:pos[2] == s:POS_ZERO
            let s:pos[2] = 1
            call setpos('.', s:pos)
        elseif s:pos[2] == s:POS_DOLLAR
            let s:pos[2] = col('$') - 1
            call setpos('.', s:pos)
        else
            call setpos('.', s:pos)
        endif
    elseif col('.') < prev_col    " if cursor was moved to the line that has fewer col than prev_col
        " backup s:pos
        let s:pos = prev_pos
    endif
endfunc
" }}}

" }}}

" Mappings {{{

nnoremap <Plug>(vim_bug_about_col_zero)   :<C-u>let <SID>pos[2] = <SID>POS_ZERO<CR>
nnoremap <Plug>(vim_bug_about_col_dollar) :<C-u>let <SID>pos[2] = <SID>POS_DOLLAR<CR>

" wrap mappings
"
" j, k
for i in ['j', 'k']
    let norm_cmd = maparg(i, 'n') == '' ? i : maparg(i, 'n')
    execute printf('nnoremap <silent> %s :<C-u>call <SID>move(%s)<CR>', i, string(norm_cmd))
endfor
" 0
let norm_cmd = maparg('0', 'n') == '' ? '0' : maparg('0', 'n')
execute printf('nnoremap <silent> %s <Plug>(vim_bug_about_col_zero)0', norm_cmd)
" $
let norm_cmd = maparg('$', 'n') == '' ? '$' : maparg('$', 'n')
execute printf('nnoremap <silent> %s <Plug>(vim_bug_about_col_dollar)$', norm_cmd)

unlet norm_cmd

" }}}

" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
" }}}
