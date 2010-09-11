" vim:set ts=8 sts=2 sw=2 tw=0:
"
" - 2ch viewer 'Chalice' /
"
" Last Change: 12-May-2002.
" Written By:  Muraoka Taro <koron@tka.att.ne.jp>

scriptencoding cp932

runtime! syntax/2ch.vim

syntax match 2chWriteTitle "^Title:\s*.*"
syntax match 2chWriteFrom "^From:\s*.*"
syntax match 2chWriteMail "^Mail:\s*.*"
syntax match 2chWriteSeparator "^--------"
syntax match 2chWriteRef display ">>\d\+\(-\d\+\)\?"
execute 'syntax match 2chWriteUrl display "\(h\?ttps\?\|ftp\)://'.g:AL_pattern_class_url.'\+"'
syntax match 2chWriteComment display "^[#Åî].*"
syntax match 2chThreadQuote1 display "^[>ÅÑ]\([>ÅÑ][>ÅÑ]\)*[^0-9>ÅÑ].*"
syntax match 2chThreadQuote2 display "^[>ÅÑ][>ÅÑ]\([>ÅÑ][>ÅÑ]\)*[^0-9>ÅÑ].*"

hi def link 2chWriteTitle		Title
hi def link 2chWriteFrom		Constant
hi def link 2chWriteMail		Identifier
hi def link 2chWriteSeparator		NonText
hi def link 2chWriteRef			2chUnderlined
hi def link 2chWriteUrl			2chUnderlined
hi def link 2chWriteComment		Comment
hi def link 2chWriteQuote1		PreProc
hi def link 2chWriteQuote2		Identifier
