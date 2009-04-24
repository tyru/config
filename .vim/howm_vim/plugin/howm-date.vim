"
" howm-date.vim - howm-mode.vim 用の日付処理ライブラリ
"
" Last Change: 04-Jun-2006.
" Written By: Kouichi NANASHIMA <claymoremine@anet.ne.jp>

scriptencoding euc-jp

" dateFormat のフォーマットで書かれた日付 date を解釈し，
" 西暦 0 年 1 月 1 日からの経過日数を返す．
function! HowmDate2Int(date, dateFormat)
  if s:date2ymd(a:date, a:dateFormat, 's:date')
    let retval = s:ymd2int(s:date_year, s:date_month, s:date_day)
  else
    let retval = -1
  endif
  unlet s:date_year
  unlet s:date_month
  unlet s:date_day

  return retval
endfunction

" dateFormat のフォーマットで書かれた日付 date を解釈し，
" {a:retvar}_year, {a:retvar}_month, {a:retvar}_day に
" それぞれ年月日を代入する．
function! s:date2ymd(date, dateFormat, retvar)
  let dateRegexp = '\v'.HowmEscapeVimPattern(a:dateFormat)
  let dateRegexp = substitute(dateRegexp, '\\%Y', '\\d{4}', '')
  let dateRegexp = substitute(dateRegexp, '\\%m', '\\d{2}', '')
  let dateRegexp = substitute(dateRegexp, '\\%d', '\\d{2}', '')
  let datePart = matchstr(a:date, dateRegexp)
  if datePart == ""
    let {a:retvar}_year  = 0
    let {a:retvar}_month = 0
    let {a:retvar}_day   = 0
    return 0
  else
    let dateRegexp = '\v'.HowmEscapeVimPattern(a:dateFormat)
    let dateRegexp = substitute(dateRegexp, '\\%Y', '(\\d{4})', '')
    let dateRegexp = substitute(dateRegexp, '\\%m', '\\d{2}', '')
    let dateRegexp = substitute(dateRegexp, '\\%d', '\\d{2}', '')
    let year = substitute(datePart, dateRegexp, '\1', '')
    let {a:retvar}_year = substitute(year, '^0*', '', '') + 0
    let dateRegexp = '\v'.HowmEscapeVimPattern(a:dateFormat)
    let dateRegexp = substitute(dateRegexp, '\\%Y', '\\d{4}', '')
    let dateRegexp = substitute(dateRegexp, '\\%m', '(\\d{2})', '')
    let dateRegexp = substitute(dateRegexp, '\\%d', '\\d{2}', '')
    let month = substitute(datePart, dateRegexp, '\1', '')
    let {a:retvar}_month = substitute(month, '^0*', '', '') + 0
    let dateRegexp = '\v'.HowmEscapeVimPattern(a:dateFormat)
    let dateRegexp = substitute(dateRegexp, '\\%Y', '\\d{4}', '')
    let dateRegexp = substitute(dateRegexp, '\\%m', '\\d{2}', '')
    let dateRegexp = substitute(dateRegexp, '\\%d', '(\\d{2})', '')
    let day = substitute(datePart, dateRegexp, '\1', '')
    let {a:retvar}_day = substitute(day, '^0*', '', '') + 0
    return 1
  endif
endfunction

" 年 y，月 m，日 d の形で日付を受け取り，
" 西暦 0 年 1 月 1 日からの経過日数を返す．
function! s:ymd2int(y, m, d)
  let d = a:d + a:y * 365 + a:m * 275 / 9

  if a:m > 2
    let d = d - 2
    let y = a:y
  else
    let y = a:y - 1
  endif
  return d + y / 4 - y / 100 + y / 400 - 31
endfunction

" 単体テスト用関数 {{{
if exists('g:howm_debug') && g:howm_debug
function! TestHowmDate()
	call TestHowmDate2Int()
	call Test_date2ymd()
	call Test_ymd2int()
endfunction

" HowmDate2Int() テスト {{{
function! TestHowmDate2Int()
  " 正常処理テスト
  call VUAssertEquals(30, HowmDate2Int('0000-01-31', '%Y-%m-%d'), '%Y-%m-%dパターンのテスト')
  call VUAssertEquals(30, HowmDate2Int('0000-31-01', '%Y-%d-%m'), '%Y-%d-%mパターンのテスト')
  call VUAssertEquals(30, HowmDate2Int('01-0000-31', '%m-%Y-%d'), '%m-%Y-%dパターンのテスト')
  call VUAssertEquals(30, HowmDate2Int('01-31-0000', '%m-%d-%Y'), '%m-%d-%Yパターンのテスト')
  call VUAssertEquals(30, HowmDate2Int('31-0000-01', '%d-%Y-%m'), '%d-%Y-%mパターンのテスト')
  call VUAssertEquals(30, HowmDate2Int('31-01-0000', '%d-%m-%Y'), '%d-%m-%Yパターンのテスト')

  call VUAssertEquals(30, HowmDate2Int('[0000-01-31]@', '[%Y-%m-%d]@'), '[%Y-%m-%d]@パターンのテスト')
  call VUAssertEquals(30, HowmDate2Int('[0000-31-01]@', '[%Y-%d-%m]@'), '[%Y-%d-%m]@パターンのテスト')
  call VUAssertEquals(30, HowmDate2Int('[01-0000-31]@', '[%m-%Y-%d]@'), '[%m-%Y-%d]@パターンのテスト')
  call VUAssertEquals(30, HowmDate2Int('[01-31-0000]@', '[%m-%d-%Y]@'), '[%m-%d-%Y]@パターンのテスト')
  call VUAssertEquals(30, HowmDate2Int('[31-0000-01]@', '[%d-%Y-%m]@'), '[%d-%Y-%m]@パターンのテスト')
  call VUAssertEquals(30, HowmDate2Int('[31-01-0000]@', '[%d-%m-%Y]@'), '[%d-%m-%Y]@パターンのテスト')

  call VUAssertEquals(30, HowmDate2Int('[0000-01-31]@ a', '[%Y-%m-%d]@'), '後ろに余分な文字のあるパターンのテスト')
  call VUAssertEquals(30, HowmDate2Int('a[0000-01-31]@', '[%Y-%m-%d]@'), '前に余分な文字のあるパターンのテスト')
  " 異常処理テスト
  call VUAssertEquals(-1, HowmDate2Int('2004-06-26', '%m-%Y-%d'), 'パターンと違う順番で日付が出現する場合のテスト')
  call VUAssertEquals(-1, HowmDate2Int('aaaa-bb-cc', '%Y-%m-%d'), '内容が日付でない場合のテスト')
endfunction
" HowmDate2Int() テスト }}}
" s:date2ymd() テスト {{{
function! Test_date2ymd()
  " 正常処理テスト
  call VUAssertEquals(1, s:date2ymd('2004-06-26', '%Y-%m-%d', 's:date'), '%Y-%m-%dパターンのテスト')
	call VUAssertEquals(2004, s:date_year)
  call VUAssertEquals(6, s:date_month)
  call VUAssertEquals(26, s:date_day)
  call VUAssertEquals(1, s:date2ymd('2004-26-06', '%Y-%d-%m', 's:date'), '%Y-%d-%mパターンのテスト')
  call VUAssertEquals(2004, s:date_year)
  call VUAssertEquals(6, s:date_month)
  call VUAssertEquals(26, s:date_day)
  call VUAssertEquals(1, s:date2ymd('06-2004-26', '%m-%Y-%d', 's:date'), '%m-%Y-%dパターンのテスト')
  call VUAssertEquals(2004, s:date_year)
  call VUAssertEquals(6, s:date_month)
  call VUAssertEquals(26, s:date_day)
  call VUAssertEquals(1, s:date2ymd('06-26-2004', '%m-%d-%Y', 's:date'), '%m-%d-%Yパターンのテスト')
  call VUAssertEquals(2004, s:date_year)
  call VUAssertEquals(6, s:date_month)
  call VUAssertEquals(26, s:date_day)
  call VUAssertEquals(1, s:date2ymd('26-2004-06', '%d-%Y-%m', 's:date'), '%d-%Y-%mパターンのテスト')
  call VUAssertEquals(2004, s:date_year)
  call VUAssertEquals(6, s:date_month)
  call VUAssertEquals(26, s:date_day)
  call VUAssertEquals(1, s:date2ymd('26-06-2004', '%d-%m-%Y', 's:date'), '%d-%m-%Yパターンのテスト')
  call VUAssertEquals(2004, s:date_year)
  call VUAssertEquals(6, s:date_month)
  call VUAssertEquals(26, s:date_day)
  call VUAssertEquals(1, s:date2ymd('[2004-06-26]@', '[%Y-%m-%d]@', 's:date'), '[%Y-%m-%d]@パターンのテスト')
  call VUAssertEquals(2004, s:date_year)
  call VUAssertEquals(6, s:date_month)
  call VUAssertEquals(26, s:date_day)
  call VUAssertEquals(1, s:date2ymd('[06-2004-26]@', '[%m-%Y-%d]@', 's:date'), '[%Y-%d-%m]@パターンのテスト')
  call VUAssertEquals(2004, s:date_year)
  call VUAssertEquals(6, s:date_month)
  call VUAssertEquals(26, s:date_day)
  call VUAssertEquals(1, s:date2ymd('[06-26-2004]@', '[%m-%d-%Y]@', 's:date'), '[%m-%Y-%d]@パターンのテスト')
  call VUAssertEquals(2004, s:date_year)
  call VUAssertEquals(6, s:date_month)
  call VUAssertEquals(26, s:date_day)
  call VUAssertEquals(1, s:date2ymd('[26-06-2004]@', '[%d-%m-%Y]@', 's:date'), '[%m-%d-%Y]@パターンのテスト')
  call VUAssertEquals(2004, s:date_year)
  call VUAssertEquals(6, s:date_month)
  call VUAssertEquals(26, s:date_day)
	call VUAssertEquals(1, s:date2ymd('[26-2004-06]@', '[%d-%Y-%m]@', 's:date'), '[%d-%Y-%m]@パターンのテスト')
  call VUAssertEquals(2004, s:date_year)
  call VUAssertEquals(6, s:date_month)
  call VUAssertEquals(26, s:date_day)
	call VUAssertEquals(1, s:date2ymd('[2004-26-06]@', '[%Y-%d-%m]@', 's:date'), '[%d-%m-%Y]@パターンのテスト')
  call VUAssertEquals(2004, s:date_year)
  call VUAssertEquals(6, s:date_month)
  call VUAssertEquals(26, s:date_day)
	call VUAssertEquals(1, s:date2ymd('2004-06-26a', '%Y-%m-%d', 's:date'), '後ろに余分な文字のあるパターンのテスト')
  call VUAssertEquals(2004, s:date_year)
  call VUAssertEquals(6, s:date_month)
  call VUAssertEquals(26, s:date_day)
	call VUAssertEquals(1, s:date2ymd('a2004-06-26', '%Y-%m-%d', 's:date'), '前に余分な文字のあるパターンのテスト')
  call VUAssertEquals(2004, s:date_year)
  call VUAssertEquals(6, s:date_month)
  call VUAssertEquals(26, s:date_day)
  " 異常処理テスト
  call VUAssertEquals(0, s:date2ymd('2004-06-26', '%m-%Y-%d', 's:date'), 'パターンと違う順番で日付が出現する場合のテスト')
  call VUAssertEquals(0, s:date2ymd('aaaa-bb-cc', '%Y-%m-%d', 's:date'), '内容が日付でない場合のテスト')
  " 後片付け
  unlet s:date_year
  unlet s:date_month
  unlet s:date_day
endfunction
" s:date2ymd() テスト }}}
" s:ymd2int() テスト {{{
function! Test_ymd2int()
  " 基準日テスト
  call VUAssertEquals(0, s:ymd2int(0, 1, 1), '基準日テスト')
  " 月変わり処理テスト
  call VUAssertEquals(1, s:ymd2int(1, 2, 1) - s:ymd2int(1, 1, 31), '月変わり処理テスト')
  call VUAssertEquals(1, s:ymd2int(1, 3, 1) - s:ymd2int(1, 2, 28), '月変わり処理テスト')
  call VUAssertEquals(1, s:ymd2int(1, 4, 1) - s:ymd2int(1, 3, 31), '月変わり処理テスト')
  call VUAssertEquals(1, s:ymd2int(1, 5, 1) - s:ymd2int(1, 4, 30), '月変わり処理テスト')
  call VUAssertEquals(1, s:ymd2int(1, 6, 1) - s:ymd2int(1, 5, 31), '月変わり処理テスト')
  call VUAssertEquals(1, s:ymd2int(1, 7, 1) - s:ymd2int(1, 6, 30), '月変わり処理テスト')
  call VUAssertEquals(1, s:ymd2int(1, 8, 1) - s:ymd2int(1, 7, 31), '月変わり処理テスト')
  call VUAssertEquals(1, s:ymd2int(1, 9, 1) - s:ymd2int(1, 8, 31), '月変わり処理テスト')
  call VUAssertEquals(1, s:ymd2int(1,10, 1) - s:ymd2int(1, 9, 30), '月変わり処理テスト')
  call VUAssertEquals(1, s:ymd2int(1,11, 1) - s:ymd2int(1,10, 31), '月変わり処理テスト')
  call VUAssertEquals(1, s:ymd2int(1,12, 1) - s:ymd2int(1,11, 30), '月変わり処理テスト')
  " 年変わり処理テスト
  call VUAssertEquals(1, s:ymd2int(2, 1, 1) - s:ymd2int(1,12, 31), '年変わり処理テスト')
  " 閏年処理テスト
  call VUAssertEquals(1, s:ymd2int(4, 3, 1) - s:ymd2int(4, 2, 29), '閏年処理テスト')
  call VUAssertEquals(1, s:ymd2int(8, 3, 1) - s:ymd2int(8, 2, 29), '閏年処理テスト')
  call VUAssertEquals(1, s:ymd2int(100, 3, 1) - s:ymd2int(100, 2, 28), '閏年処理テスト')
  call VUAssertEquals(1, s:ymd2int(200, 3, 1) - s:ymd2int(200, 2, 28), '閏年処理テスト')
  call VUAssertEquals(1, s:ymd2int(400, 3, 1) - s:ymd2int(400, 2, 29), '閏年処理テスト')
endfunction
" s:ymd2int() テスト }}}

endif
" 単体テスト用関数 }}}

" vim:set ts=2 sts=2 sw=2 tw=0 fdm=marker:
