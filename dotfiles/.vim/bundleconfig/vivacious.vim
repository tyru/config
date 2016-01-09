scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


let s:vivacious = vivacious#bundleconfig#new()

" Configuration for vivacious.
function! s:vivacious.config()
    MapAlterCommand ed[itbundle] VivaciousEditBundleConfig
    MapAlterCommand in[stall] VivaciousInstall
    MapAlterCommand re[move] VivaciousRemove
    MapAlterCommand pu[rge] VivaciousPurge
    MapAlterCommand li[st] VivaciousList
    MapAlterCommand fe[tchall] VivaciousFetchAll
    MapAlterCommand up[date] VivaciousUpdate
    " MapAlterCommand ma[nage] VivaciousManage
    MapAlterCommand en[able] VivaciousEnable
    MapAlterCommand di[sable] VivaciousDisable
endfunction

" Plugin dependencies for vivacious.
function! s:vivacious.depends()
    return []
endfunction

" Recommended plugin dependencies for vivacious.
" If the plugins are not installed, vivacious shows recommended plugins.
function! s:vivacious.recommends()
    return []
endfunction

" External commands dependencies for vivacious.
" (e.g.: curl)
function! s:vivacious.depends_commands()
    return []
endfunction

" Recommended external commands dependencies for vivacious.
" If the plugins are not installed, vivacious shows recommended commands.
function! s:vivacious.recommends_commands()
    return []
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
