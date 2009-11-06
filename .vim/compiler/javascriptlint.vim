if exists("current_compiler")
  finish
endif

if exists(":CompilerSet") != 2      " older Vim always used :setlocal
    command -nargs=* CompilerSet setlocal <args>
endif

let current_compiler = "javascriptlint"
let s:cpo_save = &cpo
set cpo-=C

CompilerSet makeprg=jsl\ -nologo\ -nofilelisting\ -nosummary\ -nocontext\ -process\ %
CompilerSet errorformat=%f(%l):\ %m

let &cpo = s:cpo_save
unlet s:cpo_save
