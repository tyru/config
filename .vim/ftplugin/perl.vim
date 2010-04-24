if exists("b:did_ftplugin") | finish | endif
if exists("loaded_perl_ftplugin") | finish | endif

let b:did_ftplugin = 1
let s:save_cpo = &cpo
set cpo&vim


" Add perl's path.
" Executing 'gf' command on module name opens its module.
if exists('$PERL5LIB') && !exists('b:perl_already_added_path')
    for i in split(expand('$PERL5LIB'), ':')
        execute 'setlocal path+=' . i
    endfor
    let b:perl_already_added_path = 1
endif

" TODO Go to module file by `gf` or `<C-w>f`.
setlocal suffixesadd=.pm
setlocal makeprg=perl\ -Mstrict\ -Mwarnings\ -c\ %
setlocal complete=.,w,b,t,k,kspell


" POD highlighting
let g:perl_include_pod = 1

" Something good
let g:perl_extended_vars = 1
let g:perl_want_scope_in_variables = 1

" Fold only sub, __END__, <<HEREDOC
let g:perl_fold = 1
unlet! g:perl_fold_blocks
let g:perl_nofold_packages = 1


" Jumping to sub definition.
nnoremap <buffer> ]]    :<C-u>call search('^\s*sub .* {$', 'sW')<CR>
nnoremap <buffer> [[    :<C-u>call search('^\s*sub .* {$', 'bsW')<CR>
nnoremap <buffer> ][    :<C-u>call search('^}$', 'sW')<CR>
nnoremap <buffer> []    :<C-u>call search('^}$', 'bsW')<CR>


let &cpo = s:save_cpo
