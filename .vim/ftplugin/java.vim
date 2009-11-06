if exists("b:did_ftplugin") | finish | endif
if exists("loaded_java_ftplugin") | finish | endif

let b:did_ftplugin = 1
let s:save_cpo = &cpo
set cpo&vim


" for javadoc
setlocal iskeyword+=@-@
setlocal makeprg=javac\ %


let &cpo = s:save_cpo
