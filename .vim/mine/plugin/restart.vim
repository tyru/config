" vim:foldmethod=marker:fen:
scriptencoding utf-8

" Document {{{
"==================================================
" Name: restart.vim
" Version: 0.0.0
" Author:  tyru <tyru.exe@gmail.com>
" Last Change: 2010-01-01.
"
" Description:
"   Restart your gVim.
"
" Change Log: {{{
"   0.0.0: Initial upload
" }}}
" Usage: {{{
"   Commands: {{{
"       :Restart
"           If modified buffer(s) exist, gVim won't restart.
"           If you want to quit anyway, add bang(:Restart!).
"   }}}
"   Global Variables: {{{
"       g:restart_command (default: 'Restart')
"           command name to restart gVim.
"   }}}
" }}}
" TODO: {{{
"   - Support vim (Is this possible...?)
" }}}
"==================================================
" }}}

" NOTE: THIS PLUGIN CAN'T WORK UNDER THE TERMINAL.
if !has('gui_running')
    finish
endif

" Load Once {{{
if exists('g:loaded_restart') && g:loaded_restart
    finish
endif
let g:loaded_restart = 1
" }}}
" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}

" Global Variables {{{
if !exists('g:restart_command')
    let g:restart_command = 'Restart'
endif
" }}}

" utility functions
" s:warn {{{
func! s:warn(msg)
    echohl WarningMsg
    echomsg a:msg
    echohl None

    call add(s:debug_errmsg, a:msg)
endfunc
" }}}
" s:warnf {{{
func! s:warnf(fmt, ...)
    call s:warn(call('printf', [a:fmt] + a:000))
endfunc
" }}}
" s:system {{{
func! s:system(command, ...)
    let args = [a:command] + map(copy(a:000), 'shellescape(v:val)')
    return system(join(args, ' '))
endfunc
" }}}

" Function to restart {{{
func! s:restart(bang)
    if a:bang !=# '!'
        try
            bmodified
            call s:warn("modified buffer(s) exist!")
            return
        catch
            " nop.
        endtry
    endif

    call s:system(
    \   'gvim',
    \   '-c', printf('set lines=%d', &lines),
    \   '-c', printf('set columns=%d', &columns),
    \   '-c', printf('winpos %s %s', getwinposx(), getwinposy()),
    \)
    execute 'qall'.a:bang
endfunc
" }}}
" Command to restart {{{
if g:restart_command != ''
    execute 'command! -bang' g:restart_command 'call s:restart("<bang>")'
endif
" }}}

" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
" }}}
