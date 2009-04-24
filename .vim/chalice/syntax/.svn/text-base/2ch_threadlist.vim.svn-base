" vim:set ts=8 sts=2 sw=2 tw=0:
"
" - 2ch viewer 'Chalice' /
"
" Last Change: 02-Jul-2002.
" Written By:  MURAOKA Taro <koron@tka.att.ne.jp>

scriptencoding cp932

runtime! syntax/2ch.vim

syntax match 2chThreadCount display "(\%(\%(\d\+\|???\)/\)\?\d\+)"
syntax match 2chThreadNewArticles display "^! .* ("hs=s+2,he=e-2,me=e-2
syntax match 2chThreadLoadedNew display "^\* .* ("hs=s+2,he=e-2,me=e-2
syntax match 2chThreadLoadedOld display "^+ .* ("hs=s+2,he=e-2,me=e-2
syntax match 2chThreadLoadedAbone display "^x .* ("hs=s+2,he=e-2,me=e-2
syntax match 2chThreadLoadedTime display "\S*\d\d\d\d/\d\d/\d\d \d\d:\d\d:\d\d"

hi def link 2chThreadCount Comment
hi def link 2chThreadNewArticles DiffChange
hi def link 2chThreadLoadedNew DiffAdd
hi def link 2chThreadLoadedOld Constant
hi def link 2chThreadLoadedAbone DiffDelete
hi def link 2chThreadLoadedTime Constant
