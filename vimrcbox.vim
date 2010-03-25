" vimrcbox.vim
" Author: Sora harakami <sora134@gmail.com>
" Modified by: thinca <thinca+vim@gmail.com> thanks!
" Modified by: Shougo <Shougo.Matsu@gmail.com> thanks!
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
    if !executable('curl')
        echoerr 'This script needs "curl". Please install.'
    endif

    let user = !empty(g:vimrcbox_user)?  g:vimrcbox_user : input("Username: ")
    if user == ''
        echo "Cancel"
        return
    endif
    let pass = !empty(g:vimrcbox_pass)?  g:vimrcbox_pass : inputsecret("Password: ")
    if pass == ''
        echo "Cancel"
        return
    endif

    if a:postfile != ''
        let postfile = a:postfile
    else
        let postfile = a:gvim ? 
                    \(g:vimrcbox_gvimrc != '' ? g:vimrcbox_gvimrc : $MYGVIMRC)
                    \: (g:vimrcbox_vimrc  != '' ? g:vimrcbox_vimrc  : $MYVIMRC)
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
        echoerr "Update failure: " . result
    end
endfunction

command! -nargs=? -complete=file RcbVimrc  call s:VrbUpdate(<q-args>, 0)
command! -nargs=? -complete=file RcbGVimrc call s:VrbUpdate(<q-args>, 1)

let &cpo = s:save_cpo
unlet s:save_cpo