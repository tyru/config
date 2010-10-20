" Vim compiler file
" Compiler:     W3C Css validator with error reporting
" Maintainer:   Cosimo Streppone <cosimo@cpan.org>
" Last Change:  Tue Jun 13 10:04:44 CEST 2006
"
" Changelog:
" 0.1:  initial release
"
" Contributors:
"
" Todo:
"   Build a complete list of W3C CSS validator errors/warnings
"
" Comments:
"   The error-format string is strictly dependent on validate_css perl script.
"   Comments and suggestions are really welcome...
"
"   I've seen that sometimes W3C validation webservice does not respond,
"   or tells that the file is ok, even if there are errors. (?)
"   It seems that Perl module SOAP::Lite v0.60a works, while v0.67 does not.
"   Anyone can confirm that?
"

if exists("current_compiler")
  finish
endif
let current_compiler = "css"

if exists(":CompilerSet") != 2
  command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo-=C

" Set `validate_css' path to whatever you installed it.
" When the script is in normal paths, vim already sees it.
CompilerSet makeprg=validate_css\ $*\ %

" Error format is very simple, because we can control it
" via `validate_css' perl script.
CompilerSet errorformat=
    \%f:%t:%l:%m.

let &cpo = s:cpo_save
unlet s:cpo_save

" vim: ft=vim
