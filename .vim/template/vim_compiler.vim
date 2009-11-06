" vim:set fdm=marker:



if exists("current_compiler")
  finish
endif

if exists(":CompilerSet") != 2      " older Vim always used :setlocal
    command -nargs=* CompilerSet setlocal <args>
endif

let current_compiler = "<% filename_noext %>"
let s:cpo_save = &cpo
set cpo-=C


" CompilerSet {{{
CompilerSet makeprg=
CompilerSet errorformat=
" }}}


let &cpo = s:cpo_save
unlet s:cpo_save
