" vim:foldmethod=marker:fen:
scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim


let s:opt = tyru#util#undo_ftplugin_helper#new()

" Add perl's path.
" Executing 'gf' command on module name opens its module.
if exists('$PERL5LIB')
    for i in split(expand('$PERL5LIB'), ':')
        call s:opt.append('path', i)
    endfor
endif

call s:opt.set('complete', '.,w,b,t,k,kspell')
call s:opt.let('makeprg', 'perl -Mstrict -Mwarnings -c %')


" For avoiding flickering
call s:opt.remove('matchpairs', '<:>')

" Jumping to sub definition.
call s:opt.map('n', ']]', ':<C-u>call search('.string('^\s*sub .* {$') .', "sW")<CR>')
call s:opt.map('n', '[[', ':<C-u>call search('.string('^\s*sub .* {$') .', "bsW")<CR>')
call s:opt.map('n', '][', ':<C-u>call search('.string('^}$') .', "sw")<CR>')
call s:opt.map('n', '[]', ':<C-u>call search('.string('^}$') .', "bsw")<CR>')


call SurroundRegister('b', 'qs', "q(\r)")
call SurroundRegister('b', 'qq', "qq(\r)")
call SurroundRegister('b', 'qw', "qw(\r)")

call SurroundRegister('b', 'qs', "q/\r/")
call SurroundRegister('b', 'qq', "qq/\r/")
call SurroundRegister('b', 'qw', "qw/\r/")

let b:undo_ftplugin = s:opt.make_undo_ftplugin()


let &cpo = s:save_cpo
