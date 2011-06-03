" vim:foldmethod=marker:fen:
scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim


call s:opt = tyru#util#undo_ftplugin_helper#new()

function! b:ref_toggle_buffer(fallback)
    if b:ref_perldoc_mode ==# 'module'
        return ":\<C-u>Ref perldoc -m "
        \       . b:ref_perldoc_word
        \       . "\<CR>"
    elseif b:ref_perldoc_mode ==# 'source'
        return ":\<C-u>Ref perldoc "
        \       . b:ref_perldoc_word
        \       . "\<CR>"
    else
        return a:fallback
    endif
endfunction
call s:opt.map(
\   'n',
\   '<LocalLeader>t',
\   'b:ref_toggle_buffer(g:maplocalleader . "t")',
\   'se'
\)

let b:undo_ftplugin = s:opt.make_undo_ftplugin()


let &cpo = s:save_cpo
