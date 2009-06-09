" vim:foldmethod=marker:fen:
scriptencoding utf-8

" DOCUMENT {{{1
"==================================================
" Name: nextfile
" Version: 0.0.2
" Author:  tyru <tyru.exe@gmail.com>
" Last Change: 2009-06-10.
"
" Change Log: {{{2
"   0.0.0: Initial upload.
"   0.0.1: add g:nf_ignore_dir
"   0.0.2: implement g:nf_ignore_ext.
" }}}2
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
"
"==================================================
" }}}1

" INCLUDE GUARD {{{1
if exists('g:loaded_nextfile') && g:loaded_nextfile != 0 | finish | endif
let g:loaded_nextfile = 1
" }}}1
" SAVING CPO {{{1
let s:save_cpo = &cpo
set cpo&vim
" }}}1

" GLOBAL VARIABLES {{{1
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
" }}}1


" FUNCTION DEFINITION {{{1

func! s:Warn(msg)
    echohl WarningMsg
    echo a:msg
    echohl None
endfunc

func! s:GetListIdx(lis, elem)
    let i = 0
    while i < len(a:lis)
        if a:lis[i] ==# a:elem
            return i
        endif
        let i = i + 1
    endwhile
    throw "not found"
endfunc

func! s:GlobPath(path, expr)
    let files = split(globpath(a:path, a:expr), '\n')
    call map(files, 'fnamemodify(v:val, ":t")')
    call filter(files, 'v:val !=# "." && v:val !=# ".."')
    call map(files, 'a:path . "/" . v:val')
    return files
endfunc

func! s:OpenNextFile(advance)
    if expand('%') ==# ''
        return s:Warn("you didn't open any file")
    endif

    try
        " get files list
        let files = s:GlobPath(expand('%:p:h'), '*')
        if g:nf_include_dotfiles
            let files += s:GlobPath(expand('%:p:h'), '.*')
        endif
        if g:nf_ignore_dir
            call filter(files, '! isdirectory(v:val)')
        endif
        for ext in g:nf_ignore_ext
            call filter(files, 'fnamemodify(v:val, ":e") !=# ext')
        endfor

        " get current file idx
        let tailed = map(copy(files), 'fnamemodify(v:val, ":t")')
        let idx = s:GetListIdx(tailed, expand('%:t'))

    catch /^not found$/
        return s:Warn('not found current file')
    endtry


    let idx = a:advance ? idx + 1 : idx - 1
    " can access files[idx]
    if idx >= 0 && get(files, idx, -1) !=# -1
        execute g:nf_open_command . ' ' . fnameescape(files[idx])
    elseif g:nf_loop_files
        let idx = idx < 0 ? idx : idx - len(files)
        execute g:nf_open_command . ' ' . fnameescape(files[idx])
    else
        call s:Warn(printf('no %s file.', a:advance ? 'next' : 'previous'))
    endif
endfunc

" }}}1

" MAPPING {{{1
execute printf('nnoremap %s :call <SID>OpenNextFile(1)<CR>', g:nf_map_next)
execute printf('nnoremap %s :call <SID>OpenNextFile(0)<CR>', g:nf_map_previous)
" }}}1

" RESTORE CPO {{{1
let &cpo = s:save_cpo
" }}}1

