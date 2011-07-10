" vim:foldmethod=marker:fen:
scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim


let s:opt = tyru#util#undo_ftplugin_helper#new()

call s:opt.map(
\   'n',
\   '<LocalLeader>t',
\   '<Plug>(ref-source-perldoc-switch)',
\   'r'
\)
" Delete default <Plug>(ref-source-perldoc-switch) mapping.
" call s:opt.unmap('n', 's', 'b')


let b:undo_ftplugin = s:opt.make_undo_ftplugin()


let &cpo = s:save_cpo
