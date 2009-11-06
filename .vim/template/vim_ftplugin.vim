if exists("b:did_ftplugin") | finish | endif
if exists("loaded_<% filename_noext %>_ftplugin") | finish | endif

let b:did_ftplugin = 1
let s:save_cpo = &cpo
set cpo&vim



let &cpo = s:save_cpo
