" vim:foldmethod=marker:fen:
scriptencoding utf-8

" DOCUMENT {{{
"==================================================
" Name: nextfile
" Version: 0.0.3
" Author:  tyru <tyru.exe@gmail.com>
" Last Change: 2009-11-11.
"
" Description:
"   open the next or previous file
"
" Change Log: {{{
"   0.0.0: Initial upload.
"   0.0.1: add g:nf_ignore_dir
"   0.0.2: implement g:nf_ignore_ext.
" }}}
"
"
" Usage:
"
"   MAPPING:
"       default:
"           <Leader>n - open the next file
"           <Leader>p - open the previous file
"
"   GLOBAL VARIABLES:
"       g:nf_map_next (default: '<Leader>n')
"           open the next file.
"
"       g:nf_map_previous (default: '<Leader>p')
"           open the previous file.
"
"       g:nf_include_dotfiles (default: 0)
"           if true, open the next dotfile.
"           if false, skip the next dotfile.
"
"       g:nf_open_command (default: 'edit')
"           open the (next|previous) file with this command.
"
"       g:nf_loop_files (default: 0)
"           if true, loop when reached the end.
"
"       g:nf_ignore_dir (default: 1)
"           if true, skip directory.
"
"       g:nf_ignore_ext (default: [])
"           ignore files of these extensions.
"           e.g.: "o", "obj", "exe"
"
"       g:nf_disable_if_empty_name (default: 0)
"           do not run mapping if current file name is empty.
"
"       g:nf_commands (default: see below)
"           command's names.
"           if you do not want to define some commands,
"           please leave '' in command's value.
"               e.g.: let g:nf_commands = {'NFLoadGlob': ''}
"
"           default value:
"               let g:nf_commands = {
"               \   'NFLoadGlob' : 'NFLoadGlob',
"               \   'NFNext'     : 'NFNext',
"               \   'NFPrev'     : 'NFPrev',
"               \ }
"
"       g:nf_sort_funcref (default: '<SID>sort_compare')
"           function string or Funcref passed to sort().
"
"           default function's definition:
"               func! s:sort_compare(i, j)
"                   " alphabetically
"                   return a:i > a:j
"               endfunc
"
"   COMMANDS:
"       :NFLoadGlob
"           load globbed files.
"           this command just load files to buffers, does not edit them.
"           g:nf_include_dotfiles, g:nf_ignore_*, etc. influence globbed file's list.
"               :NFLoadGlob *   " to load all files in current directory.
"       :NFNext
"           open next file.
"           you can pass the number of loading buffers.
"       :NFPrev
"           open previous file.
"           you can pass the number of loading buffers.
"
"
" TODO
" - add option of list of patterns to skip specified files
"==================================================
" }}}

" INCLUDE GUARD {{{
if exists('g:loaded_nextfile') && g:loaded_nextfile != 0 | finish | endif
let g:loaded_nextfile = 1
" }}}
" SAVING CPO {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}

" GLOBAL VARIABLES {{{
if ! exists('g:nf_map_next')
    let g:nf_map_next = '<Leader>n'
endif
if ! exists('g:nf_map_previous')
    let g:nf_map_previous = '<Leader>p'
endif
if ! exists('g:nf_include_dotfiles')
    let g:nf_include_dotfiles = 0
endif
if ! exists('g:nf_open_command')
    let g:nf_open_command = 'edit'
endif
if ! exists('g:nf_loop_files')
    let g:nf_loop_files = 0
endif
if ! exists('g:nf_ignore_dir')
    let g:nf_ignore_dir = 1
endif
if ! exists('g:nf_ignore_ext') || type(g:nf_ignore_ext) != type([])
    let g:nf_ignore_ext = []
endif
if ! exists('g:nf_disable_if_empty_name')
    let g:nf_disable_if_empty_name = 0
endif
if ! exists('g:nf_sort_funcref')
    let g:nf_sort_funcref = '<SID>sort_compare'
endif

let s:commands = {
\   'NFLoadGlob' : 'NFLoadGlob',
\   'NFNext'     : 'NFNext',
\   'NFPrev'     : 'NFPrev',
\ }
if ! exists('g:nf_commands')
    let g:nf_commands = s:commands
else
    call extend(g:nf_commands, s:commands, 'keep')
endif
unlet s:commands
" }}}


" FUNCTION DEFINITION {{{

" UTIL FUNCTION {{{
func! s:warn(msg)
    echohl WarningMsg
    echomsg a:msg
    echohl None
endfunc

func! s:warnf(fmt, ...)
    call s:warn(call('printf', [a:fmt] + a:000))
endfunc

func! s:get_idx_of_list(lis, elem)
    let i = 0
    while i < len(a:lis)
        if a:lis[i] ==# a:elem
            return i
        endif
        let i = i + 1
    endwhile
    throw "not found"
endfunc

func! s:glob_list(expr)
    let files = split(glob(a:expr), '\n')
    " get rid of '.' and '..'
    call filter(files, 'fnamemodify(v:val, ":t") !=# "." && fnamemodify(v:val, ":t") !=# ".."')
    return files
endfunc

func! s:sort_compare(i, j)
    " alphabetically
    return a:i > a:j
endfunc
" }}}



func! s:get_files_list(...)
    let glob_expr = a:0 == 0 ? '*' : a:1
    " get files list
    let files = s:glob_list(expand('%:p:h') . '/' . glob_expr)
    if g:nf_include_dotfiles
        let files += s:glob_list(expand('%:p:h') . '/.*')
    endif
    if g:nf_ignore_dir
        call filter(files, '! isdirectory(v:val)')
    endif
    for ext in g:nf_ignore_ext
        call filter(files, 'fnamemodify(v:val, ":e") !=# ext')
    endfor

    return sort(files, g:nf_sort_funcref)
endfunc

func! s:get_idx(files, advance)
    try
        " get current file idx
        let tailed = map(copy(a:files), 'fnamemodify(v:val, ":t")')
        let idx = s:get_idx_of_list(tailed, expand('%:t'))
        " move to next or previous
        let idx = a:advance ? idx + 1 : idx - 1
    catch /^not found$/
        " open the first file.
        let idx = 0
    endtry
    return idx
endfunc

func! s:open_next_file(advance)
    if g:nf_disable_if_empty_name && expand('%') ==# ''
        return s:warn("current file is empty.")
    endif

    let files = s:get_files_list()
    if empty(files) | return | endif
    let idx   = s:get_idx(files, a:advance)

    if get(files, idx, -1) !=# -1
        " can access to files[idx]
        execute g:nf_open_command fnameescape(files[idx])
    elseif g:nf_loop_files
        let idx = idx < 0 ? idx : idx - len(files)
        execute g:nf_open_command fnameescape(files[idx])
    else
        call s:warnf('no %s file.', a:advance ? 'next' : 'previous')
    endif
endfunc

func! s:cmd_load_glob(...)
    let files = []
    for glob_expr in a:000
        " NOTE: load only 'files' currently
        let files += filter(s:glob_list(glob_expr), 'filereadable(v:val)')
    endfor
    " call sort(files, g:nf_sort_funcref)
    call s:warnf('a:000 [%s], files [%s]', string(a:000), string(files))

    let save_pos   = getpos('.')
    let save_bufnr = bufnr('%')
    try
        for f in files
            execute 'edit' f
        endfor
    finally
        call setpos('.', save_pos)
        execute save_bufnr . 'buffer'
    endtry
endfunc

func! s:cmd_next_prev(is_next, ...)
    try
        let times = range(1, a:0 == 0 ? 1 : str2nr(a:1))
    catch
        " out of range
        return
    endtry
    for i in times
        call s:open_next_file(a:is_next)
    endfor
endfunc

" }}}

" MAPPING {{{
execute printf('nnoremap <silent><unique> %s :call <SID>open_next_file(1)<CR>', g:nf_map_next)
execute printf('nnoremap <silent><unique> %s :call <SID>open_next_file(0)<CR>', g:nf_map_previous)
" }}}

" COMMANDS {{{
let s:command_def = {
\   'NFLoadGlob' : ['-nargs=+', 'call s:cmd_load_glob(<f-args>)'],
\   'NFNext'     : ['-nargs=?', 'call s:cmd_next_prev(1,<f-args>)'],
\   'NFPrev'     : ['-nargs=?', 'call s:cmd_next_prev(0,<f-args>)'],
\ }
for [cmd, name] in items(g:nf_commands)
    if !empty(name)
        let [opt, def] = s:command_def[cmd]
        execute printf("command %s %s %s", opt, name, def)
    endif
endfor
unlet s:command_def
" }}}

" RESTORE CPO {{{
let &cpo = s:save_cpo
" }}}

