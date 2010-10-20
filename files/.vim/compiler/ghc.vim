" Vim compiler file
" Compiler: GHC

if exists("current_compiler")
    finish
endif
let current_compiler = "ghc"

if exists(":CompilerSet") != 2      " older Vim always used :setlocal
    command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=ghc\ --make\ -v0\ Main\ -fwarn-unused-binds\ -fwarn-unused-imports\ -fwarn-unused-matches\ -prof\ -auto-all
CompilerSet errorformat=
    \%f:%l:%v:\ %tarning:\ %m,
    \%f:%l:%v:\ %m,
    \%A%f:%l:%v:,
    \%C\ \ \ \ \ \ %[%^\ ]%\\@=%m,
    \%Z\ \ \ \ %[%^\ ]%\\@=%m,
    \%E%>Module\ imports\ form\ a\ cycle\ for\ modules:,
    \%C%>%*\\s%m
