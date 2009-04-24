"
" howm_importantdate.vim - vim 用 howm の 予定や Todo に関するシンタックス．
"
" Last Change: 04-Jun-2006.
" Written By: Kouichi NANASHIMA <claymoremine@anet.ne.jp>

scriptencoding euc-jp

let s:pattern_date      = g:howm_date_pattern
  let s:pattern_date      = substitute(s:pattern_date, '%Y', '\\(\\d\\{4}\\)', '')
  let s:pattern_date      = substitute(s:pattern_date, '%m', '\\(\\d\\{2}\\)', '')
  let s:pattern_date      = substitute(s:pattern_date, '%d', '\\(\\d\\{2}\\)', '')

exe 'syntax match howmNote display "\['.s:pattern_date.'\]-\d*"'
exe 'syntax match howmTodo display "\['.s:pattern_date.'\]+\d*"'
exe 'syntax match howmDeadline display "\['.s:pattern_date.'\]!\d*"'
exe 'syntax match howmSchedule display "\['.s:pattern_date.'\]@"'
exe 'syntax match howmFinished display "\['.s:pattern_date.'\]\."'
exe 'syntax match howmToday display "\(\[' . strftime(g:howm_date_pattern) . '\][-!@+.]\d*\)\@<=.*$"'
exe 'syntax match howmTomorrow display "\(\[' . strftime(g:howm_date_pattern, localtime() + 86400) . '\][-!@+.]\d*\)\@<=.*$"'

if g:howm_reminder_old_format != 0
  exe 'syntax match howmNote display "@\['.s:pattern_date.'\]\(-\d\+\)\?"'
  exe 'syntax match howmTodo display "@\['.s:pattern_date.'\]+\d*"'
  exe 'syntax match howmDeadline display "@\['.s:pattern_date.'\]!\d*"'
  exe 'syntax match howmSchedule display "@\['.s:pattern_date.'\]@"'
  exe 'syntax match howmFinished display "@\['.s:pattern_date.'\]\."'
  exe 'syntax match howmToday display "\(@\[' . strftime(g:howm_date_pattern) . '\]\(-\d\+\|[!@+.]\d*\)\?\)\@<=.*$"'
  exe 'syntax match howmTomorrow display "\(@\[' . strftime(g:howm_date_pattern, localtime() + 86400) . '\]\(-\d\+\|[!@+.]\d*\)\?\)\@<=.*$"'
endif

hi howmNote ctermfg=Blue ctermbg=Grey guifg=Blue guibg=#d0d0d0
hi howmTodo ctermfg=Yellow ctermbg=Grey guifg=Yellow guibg=#d0d0d0
hi howmDeadline ctermfg=Red ctermbg=Grey guifg=Red guibg=#d0d0d0
hi howmSchedule ctermfg=Green ctermbg=Grey guifg=Green guibg=#d0d0d0
hi howmFinished ctermfg=DarkGrey ctermbg=Grey guifg=DarkGrey guibg=#d0d0d0
hi howmToday ctermfg=Black ctermbg=Yellow guifg=Black guibg=Orange
hi howmTomorrow ctermfg=Black ctermbg=DarkYellow guifg=White guibg=Brown
