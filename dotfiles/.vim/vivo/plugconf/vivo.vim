scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


let s:vivo = vivo#plugconf#new()

" Configuration for vivo.
function! s:vivo.config()
    MapAlterCommand ed[itbundle] VivoEditPlugConf
    MapAlterCommand in[stall] VivoInstall
    MapAlterCommand re[move] VivoRemove
    MapAlterCommand pu[rge] VivoPurge
    MapAlterCommand li[st] VivoList
    MapAlterCommand fe[tchall] VivoFetchAll
    MapAlterCommand up[date] VivoUpdate
    " MapAlterCommand ma[nage] VivoManage
    MapAlterCommand en[able] VivoEnable
    MapAlterCommand di[sable] VivoDisable
endfunction

" Plugin dependencies for vivo.
function! s:vivo.depends()
    return []
endfunction

" Recommended plugin dependencies for vivo.
" If the plugins are not installed, vivo shows recommended plugins.
function! s:vivo.recommends()
    return []
endfunction

" External commands dependencies for vivo.
" (e.g.: curl)
function! s:vivo.depends_commands()
    return []
endfunction

" Recommended external commands dependencies for vivo.
" If the plugins are not installed, vivo shows recommended commands.
function! s:vivo.recommends_commands()
    return []
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
