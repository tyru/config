" vim:foldmethod=marker:fen:
scriptencoding utf-8

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

setlocal complete=.,w,b,t,k,kspell
let &l:makeprg = 'perl -Mstrict -Mwarnings -c %'


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



call SurroundRegister('b', 'qs', "q(\r)")
call SurroundRegister('b', 'qq', "qq(\r)")
call SurroundRegister('b', 'qw', "qw(\r)")

call SurroundRegister('b', 'qs', "q/\r/")
call SurroundRegister('b', 'qq', "qq/\r/")
call SurroundRegister('b', 'qw', "qw/\r/")


let &cpo = s:save_cpo
