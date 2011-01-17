" vim:foldmethod=marker:fen:
scriptencoding utf-8

" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}



if !exists('g:stashbuf#open_command')
    let g:stashbuf#open_command = 'vertical botright new'
endif
if !exists('g:stashbuf#no_default_keymappings')
    let g:stashbuf#no_default_keymappings = 0
endif
if !exists('g:stashbuf#no_default_current_keymappings')
    let g:stashbuf#no_default_current_keymappings = 0
endif



function! stashbuf#load() "{{{
    " dummy function to load this script file.
endfunction "}}}



function! stashbuf#start() "{{{
    call s:set_up_stashbuf_buffer()
    let stashbuf_bufnr = bufnr('%')

    wincmd p

    call s:set_up_current_buffer()
    let b:stashbuf_bufnr = stashbuf_bufnr
endfunction "}}}
function! s:set_up_stashbuf_buffer() "{{{
    execute g:stashbuf#open_command

    setlocal bufhidden=wipe
    setlocal buftype=nofile
    setlocal nobuflisted
    setlocal noswapfile

    file __stash_buffer__

    " Keymappings
    nnoremap <buffer><silent> <Plug>(stashbuf-close) :<C-u>close<CR>

    if !g:stashbuf#no_default_keymappings
        nmap <buffer> <Esc> <Plug>(stashbuf-close)
    endif

    " Filetype
    setfiletype stashbuf
endfunction "}}}
function! s:set_up_current_buffer() "{{{
    nnoremap <buffer><silent> <Plug>(stashbuf-current-yy) :<C-u>call <SID>buf_current_yy()<CR>
    nnoremap <buffer><silent> <Plug>(stashbuf-current-dd) :<C-u>call <SID>buf_current_dd()<CR>

    if !g:stashbuf#no_default_current_keymappings
        nmap <buffer> yy <Plug>(stashbuf-current-yy)
        nmap <buffer> dd <Plug>(stashbuf-current-dd)
    endif
endfunction "}}}



" Keymapping functions corresponded by <expr>
function! s:buf_current_yy() "{{{
    call s:send_register_string_to_stashbuf('yy')
endfunction "}}}
function! s:buf_current_dd() "{{{
    call s:send_register_string_to_stashbuf('dd')
endfunction "}}}

function! s:send_register_string_to_stashbuf(cmd) "{{{
    " Save @z register.
    let save_reg     = getreg('z', 1)
    let save_regtype = getregtype('z')

    try
        " a:cmd must take register as prefix (e.g.: yy, dd).
        execute 'normal! "z' . a:cmd
        let reg     = getreg('z', 1)
        let regtype = getregtype('z')
        if regtype ==# 'v'
            let last_line = getbufline(b:stashbuf_bufnr, 1, '$')[-1]
            call s:set_buf_line(b:stashbuf_bufnr, '$', last_line . reg)
        elseif regtype ==# 'V'
            let stashbuf_lines = getbufline(b:stashbuf_bufnr, 1, '$')
            if len(stashbuf_lines) == 1 && stashbuf_lines[0] == ''
                call s:set_buf_line(b:stashbuf_bufnr, 1, s:chomp(reg))
            else
                call s:add_buf_line(b:stashbuf_bufnr, s:chomp(reg))
            endif
        elseif regtype[0] ==# "\<C-v>"
            let width = regtype[1:]
            " TODO
        endif
    finally
        call setreg('z', save_reg, save_regtype)
    endtry
endfunction "}}}



" Utility functions

function! s:chomp(str) "{{{
    return substitute(a:str, '\n$', '', '')
endfunction "}}}

function! s:set_buf_line(bufnr, lnum, text) "{{{
    let winnr = bufwinnr(a:bufnr)
    if winnr == -1
        " TODO: Show error
        return
    endif

    execute winnr 'wincmd w'
    let lnum = a:lnum =~# '^\d\+$' ? a:lnum : line(a:lnum)
    call setline(lnum, a:text)
    wincmd p
endfunction "}}}

function! s:add_buf_line(bufnr, text) "{{{
    let winnr = bufwinnr(a:bufnr)
    if winnr == -1
        " TODO: Show error
        return
    endif

    execute winnr 'wincmd w'
    call setline(line('$') + 1, a:text)
    wincmd p
endfunction "}}}



" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
" }}}
