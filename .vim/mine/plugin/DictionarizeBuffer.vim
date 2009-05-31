" vim:foldmethod=marker:fen:
scriptencoding utf-8

" DOCUMENT {{{1
"==================================================
" Name: DictionarizeBuffer
" Version: 0.0.0
" Author:  tyru <tyru.exe@gmail.com>
" Last Change: 2009-05-31.
"
" Usage: this is setting up your 'dictionary' option automatically.
"
"
"==================================================
" }}}1

" INCLUDE GUARD {{{1
if exists('g:loaded_dictionarize_buffer') && g:loaded_dictionarize_buffer != 0 | finish | endif
let g:loaded_dictionarize_buffer = 1
" }}}1
" SAVING CPO {{{1
let s:save_cpo = &cpo
set cpo&vim
" }}}1

let s:previous_name = ''

" FUNCTION {{{1

" s:Warn(msg) {{{2
func! s:Warn(msg)
    echohl WarningMsg
    echo a:msg
    echohl None
endfunc
" }}}2

" s:EditDict(action, value) {{{2
func! s:EditDict(action, value)
    if a:value == '' | return | endif

    if a:action ==# 'add'
        if filereadable(a:value)
            let &dict .= ',' . a:value
        else
            call s:Warn(fname . '%s does not exist.')
        endif

    elseif a:action ==# 'remove'
        let dictlist = []
        let deleted = 0

        for d in split(&dict, ',')
            if d !=# a:value
                let dictlist += [d]
                let deleted = 1
            endif
        endfor

        if deleted
            let &dict = join(dictlist, ',')
        else
            call s:Warn(a:value . ': No such dictionary')
        endif
    endif
endfunc
" }}}2

" }}}1

" AUTOCOMMAND {{{1
augroup DictionarizeBufferAutoCommand
    autocmd!
    " save current buffer as dictionary.
    autocmd BufReadPost *   call s:EditDict('add', expand('%:p'))
    " delete dictionary.
    autocmd BufDelete   *   call s:EditDict('remove', expand('%:p'))
    " save buffer name being renamed.
    autocmd BufFilePre  *   let s:previous_name = expand('%:p')
    " register renamed buffer name.
    autocmd BufFilePost *   if s:previous_name != ''
                              \ call s:EditDict('remove', s:previous_name)
                              \ call s:EditDict('add', expand('%:p'))
                              \ let s:previous_name = ''
                          \ endif
augroup END
" }}}1

" RESTORE CPO {{{1
let &cpo = s:save_cpo
" }}}1
