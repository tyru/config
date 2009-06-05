" vim:foldmethod=marker:fen:
scriptencoding utf-8

" DOCUMENT {{{1
"==================================================
" Name: nextfile
" Version: 0.0.1
" Author:  tyru <tyru.exe+vim@gmail.com>
" Last Change: 2009-04-10.
"
" Change Log: {{{2
"   0.0.0: Initial upload.
"   0.0.1: add g:nf_ignore_dir
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
"       g:loaded_nextfile
"           if you don't want use this, you may delete this :)
"
"       g:nf_map_next (default: '<Leader>n')
"           open next file.
"
"       g:nf_map_previous (default: '<Leader>p')
"           open previous file.
"
"       g:nf_include_dotfiles (default: 0)
"           let this true if you want to include dotfiles.
"
"       g:nf_open_command (default: 'edit')
"           open the (next|previous) file with this command.
"
"       g:nf_loop_files (default: 0)
"           loop when reached the end.
"
"       g:nf_ignore_dir (default: 1)
"           ignore directory
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
    return -1
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

        " get current file idx
        let tailed = map(copy(files), 'fnamemodify(v:val, ":t")')
        let idx = s:GetListIdx(tailed, expand('%:t'))
        if idx ==# -1 | throw "not found" | endif

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

