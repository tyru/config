if exists("b:did_ftplugin") | finish | endif
if exists("loaded_perl_ftplugin") | finish | endif

let b:did_ftplugin = 1
let s:save_cpo = &cpo
set cpo&vim


" add perl's path.
" executing 'gf' command on module name opens its module.
if exists('$PERL5LIB') && !exists('b:perl_already_added_path')
    for i in split(expand('$PERL5LIB'), ':')
        execute 'setlocal path+=' . i
    endfor
    let b:perl_already_added_path = 1
endif

setlocal suffixesadd=.pm
setlocal makeprg=perl\ -Mstrict\ -Mwarnings\ -c\ %
setlocal complete=.,w,b,t,k,kspell

" jumping to sub definition.
nnoremap <buffer> ]]    :call search('^\s*sub .* {$', 'sW')<CR>
nnoremap <buffer> [[    :call search('^\s*sub .* {$', 'bsW')<CR>
nnoremap <buffer> ][    :call search('^}$', 'sW')<CR>
nnoremap <buffer> []    :call search('^}$', 'bsW')<CR>


let &cpo = s:save_cpo
