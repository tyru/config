"
" howm.vim - vim 用 howm のシンタックス．
"
" Last Change: 04-Jun-2006.
" Written By: Kouichi NANASHIMA <claymoremine@anet.ne.jp>

scriptencoding euc-jp

runtime! syntax/howm_importantdate.vim

if has('gui_running')
	hi def link howmUnderlined Underlined
else
	hi def link howmUnderlined Directory
endif
let s:pattern_date      = g:howm_date_pattern
  let s:pattern_date      = substitute(s:pattern_date, '%Y', '\\(\\d\\{4}\\)', '')
  let s:pattern_date      = substitute(s:pattern_date, '%m', '\\(\\d\\{2}\\)', '')
  let s:pattern_date      = substitute(s:pattern_date, '%d', '\\(\\d\\{2}\\)', '')

exe 'syntax match howmMemoTitle display "\(^'.g:howm_title_pattern.' \)\@<=.*"'
exe 'syntax match howmActionLock display "'.g:howm_glink_pattern.'.*"'
exe 'syntax match howmActionLock display "'.g:howm_clink_pattern.'"'
if g:howm_keyword != '\V\(\)'
  exe 'syntax match howmActionLock display "\v('.g:howm_keyword.')"'
endif
exe 'syntax match howmActionLock display "'.s:pattern_date.'"'
syntax match howmActionLock display "s\?https\?:\/\/[-_.!~*'()a-zA-Z0-9;/?:@&=+$,%#]\+"
syntax match howmActionLock display "{_}"
syntax match howmActionLock display "{[-* ]}"

hi def link howmMemoTitle Title
hi def link howmActionLock      howmUnderlined
