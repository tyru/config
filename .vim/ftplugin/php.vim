if exists("b:did_ftplugin") | finish | endif
if exists("loaded_php_ftplugin") | finish | endif

let b:did_ftplugin = 1
let s:save_cpo = &cpo
set cpo&vim


let php_folding = 1
let php_sql_query = 1


let &cpo = s:save_cpo
