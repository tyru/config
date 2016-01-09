" vim:foldmethod=marker:fen:
scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

" Add perl's path.
" Executing 'gf' command on module name opens its module.
if exists('$PERL5LIB')
    for i in split(expand('$PERL5LIB'), ':')
        let &l:path .= ',' . i
    endfor
endif

setlocal complete=.,w,b,t,k,kspell
setlocal makeprg=perl\ -Mstrict\ -Mwarnings\ -c\ %

" For avoiding flickering
setlocal matchpairs-=<:>

" Jumping to sub definition.
nnoremap <buffer> ]]    :<C-u>call search('^\s*sub .* {$', 'sW')<CR>
nnoremap <buffer> [[    :<C-u>call search('^\s*sub .* {$', 'bsW')<CR>
nnoremap <buffer> ][    :<C-u>call search('^}$', 'sw')<CR>
nnoremap <buffer> []    :<C-u>call search('^}$', 'bsw')<CR>

call SurroundRegister('b', 'qs', "q(\r)")
call SurroundRegister('b', 'qq', "qq(\r)")
call SurroundRegister('b', 'qw', "qw(\r)")

call SurroundRegister('b', 'qs', "q/\r/")
call SurroundRegister('b', 'qq', "qq/\r/")
call SurroundRegister('b', 'qw', "qw/\r/")

let b:undo_ftplugin = 'setlocal path< complete< makeprg< matchpairs< | '
\                   . 'nunmap <buffer> ]] | '
\                   . 'nunmap <buffer> [[ | '
\                   . 'nunmap <buffer> ][ | '
\                   . 'nunmap <buffer> []'

let &cpo = s:save_cpo
