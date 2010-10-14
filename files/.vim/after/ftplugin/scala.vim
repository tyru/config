" vim:foldmethod=marker:fen:
scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim


runtime! ftplugin/java.vim
runtime! compiler/java.vim

setlocal includeexpr=substitute(v:fname,'\\.','/','g')
setlocal suffixesadd=.scala
setlocal suffixes+=.class
setlocal comments& comments^=s1:/*,mb:*,ex:*/,://
setlocal commentstring=//%s
setlocal formatoptions-=t formatoptions+=croql
setlocal makeprg=


let &cpo = s:save_cpo
