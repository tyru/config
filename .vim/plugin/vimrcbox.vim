" vimrcbox.vim
" Author: Sora harakami <sora134@gmail.com>
" Modified by: thinca <thinca@gmail.com>
" Require: curl
" Licence: MIT Licence

if exists('g:loaded_vimrcbox')
    finish
endif
let g:loaded_vimrcbox = 1

let s:save_cpo = &cpo
set cpo&vim

if !exists('g:vimrcbox_user')
    let g:vimrcbox_user = ''
endif

if !exists('g:vimrcbox_pass')
    let g:vimrcbox_pass = ''
endif

if !exists('g:vimrcbox_vimrc')
    let g:vimrcbox_vimrc = ''
endif

if !exists('g:vimrcbox_gvimrc')
    let g:vimrcbox_gvimrc = ''
endif

if !exists('g:vimrcbox_baseurl')
    let g:vimrcbox_baseurl = 'http://soralabo.net/s/vrcb/'
endif



function! s:VrbUpdate(postfile, gvim)
    let user = g:vimrcbox_user
    let pass = g:vimrcbox_pass

    let postfile = a:postfile != ''
    \ ? a:postfile
    \ : a:gvim
    \   ? (g:vimrcbox_gvimrc != '' ? g:vimrcbox_gvimrc : $MYGVIMRC)
    \   : (g:vimrcbox_vimrc  != '' ? g:vimrcbox_vimrc  : $MYVIMRC)

    if user == ''
        let user = input("Username: ")
        if empty(user)
            echo "Cancel"
            return
        endif
    endif
    if pass == ''
        let pass = inputsecret("Password: ")
        if empty(pass)
            echo "Cancel"
            return
        endif
    endif
    "post
    let result = system('curl -s ' . join(values(map({
        \ 'vimrc': '@' . fnamemodify(expand(postfile), ':p'),
        \ 'user': user,
        \ 'pass': pass,
        \ 'gvim': a:gvim,
        \ }, '"-F " . shellescape(v:key . "=" . v:val)')), ' ')
        \ . ' ' . shellescape(g:vimrcbox_baseurl . 'api/register'))
    if result =~ '1'
        echo "Update success"
    else
        echo "Update failure"
    end
endfunction

command! -nargs=? -complete=file RcbVimrc  :call s:VrbUpdate(<q-args>, 0)
command! -nargs=? -complete=file RcbGVimrc :call s:VrbUpdate(<q-args>, 1)

let &cpo = s:save_cpo
unlet s:save_cpo

