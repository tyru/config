if exists("b:did_ftplugin") | finish | endif
if exists("loaded_scala_ftplugin") | finish | endif

let b:did_ftplugin = 1
let s:save_cpo = &cpo
set cpo&vim


runtime ftplugin/java.vim
runtime compiler/java.vim

setlocal includeexpr=substitute(v:fname,'\\.','/','g')
setlocal suffixesadd=.scala
setlocal suffixes+=.class
setlocal comments& comments^=s1:/*,mb:*,ex:*/,://
setlocal commentstring=//%s
setlocal formatoptions-=t formatoptions+=croql
setlocal makeprg=


let &cpo = s:save_cpo
