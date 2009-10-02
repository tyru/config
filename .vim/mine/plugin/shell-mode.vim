" vim:foldmethod=marker:fen:
scriptencoding utf-8

" DOCUMENT {{{1
"==================================================
" Name: shell-mode
" Version: 0.0.0
" Author:  tyru <tyru.exe@gmail.com>
" Last Change: 2009-10-02.
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
"       g:shellmode_prompt (default:"$ ")
"
"       TODO g:open_with (default:"win")
"           buf: not create new buffer
"           win: create new buffer
"           tab: create new tab buffer
"
"       TODO g:shellmode_max_result (default:5)
"
"
"
"==================================================
" }}}1

" INCLUDE GUARD {{{1
if exists('g:loaded_shell_mode') && g:loaded_shell_mode != 0 | finish | endif
let g:loaded_shell_mode = 1
" }}}1
" SAVING CPO {{{1
let s:save_cpo = &cpo
set cpo&vim
" }}}1

" SCOPED VARIABLES {{{1
let s:shell_bufnr = -1
let s:showed_prompt = 0
let s:curbuf_lnum = 1
let s:open_with = {
    \ 'buf' : ['edit', 'edit'],
    \ 'win' : ['new', 'split'],
    \ 'tab' : ['tabedit', 'tabedit']
\ }
" }}}1
" GLOBAL VARIABLES {{{1
if ! exists('g:shellmode_prompt')
    let g:shellmode_prompt = '$ '
endif
if ! exists('g:shellmode_max_result')
    let g:shellmode_max_result = 5
endif
if ! exists('g:shellmode_open_with') || get(s:open_with, g:shellmode_open_with, -1) ==# -1
    let g:shellmode_open_with = 'win'
endif
" }}}1

" FUNCTION DEFINITION {{{1

" s:warn(msg) {{{2
func! s:warn(msg)
    echohl WarningMsg
    echo a:msg
    echohl None
endfunc
" }}}2

" s:start_shell() {{{2
func! s:start_shell()
    call s:create_buffer()

    " map
    cnoremap <buffer> <CR>
                \ <HOME>EvalCmd<Space><CR>

    " command
    command! -buffer -nargs=+ EvalCmd
                \ call s:eval_command(<f-args>)

    call s:goto_cmdline()
endfunc
" }}}2

" s:create_buffer() {{{2
func! s:create_buffer()
    if s:shell_bufnr == -1
        new __shell__

        setlocal bufhidden=unload
        setlocal buftype=nofile
        setlocal cursorline
        setlocal nobuflisted
        setlocal nomodifiable
        setlocal noswapfile

        let s:shell_bufnr = bufnr('%')
    else
        execute s:shell_bufnr . 'split'
    endif
endfunc
" }}}2

" s:eval_command(...) {{{2
func! s:eval_command(...)
    if a:0 == 0 | return | endif
    let stdout = system(join(a:000, ' '))
    call s:write_result(a:000, stdout, '')
endfunc
" }}}2

" s:write_result() {{{2
func! s:write_result(args, stdout, stderr)
    let [args, stdout, stderr] = [a:args, a:stdout, a:stderr]

    " go to current line num
    call cursor(s:curbuf_lnum, 0)

    " increment line num of current shell buffer
    let [i, len] = [0, strlen(stdout)]
    while i < len
        if stdout[i] == "\n"
            let s:curbuf_lnum = s:curbuf_lnum + 1
        endif
        let i = i + 1
    endwhile
    let s:curbuf_lnum = s:curbuf_lnum + 1

    " paste
    let stdout = printf("%s%s\n", g:shellmode_prompt, join(args, ' ')) . stdout
    call s:put_reg_to_buffer('z', stdout)
endfunc
" }}}2

" s:put_reg_to_buffer {{{
func! s:put_reg_to_buffer(reg, str)
    let val = getreg('z', 1)
    let mode = getregtype('z')
    call setreg('z', a:str)

    setlocal modifiable
    put z
    setlocal nomodifiable

    call setreg('z', val, mode)
endfunc
" }}}

" s:goto_cmdline() {{{2
func! s:goto_cmdline()
    if s:showed_prompt | return | endif
    call feedkeys(':', 'n')
    let s:showed_prompt = 1
endfunc
" }}}2

" }}}1

" COMMAND {{{1
command! VimShell
            \ call s:start_shell()
" }}}1

" MAPPING {{{1
" }}}1

" AUTOCOMMAND {{{1
augroup shell_mode_augroup
    autocmd!

    autocmd BufEnter __shell__
                \ call s:goto_cmdline()
    autocmd BufLeave __shell__
                \ let s:showed_prompt = 0
augroup END
" }}}1

" RESTORE CPO {{{1
let &cpo = s:save_cpo
" }}}1

