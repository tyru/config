"
" howm-pattern.vim - howm-mode.vim 用の文字列パターン処理ライブラリ
"
" Last Change: 04-Jun-2006.
" Written By: Kouichi NANASHIMA <claymoremine@anet.ne.jp>

scriptencoding euc-jp

function! HowmEscapeVimPattern(pattern)
  let retval = escape(a:pattern, '\\.*+@{}<>~^$()|?[]%=&')
  let retval = retval
  return retval
endfunction

" 単体テスト用関数 {{{
if exists('g:howm_debug') && g:howm_debug
function! TestHowmPattern()
	call TestHowmEscapeVimPattern()
endfunction

function! TestHowmEscapeVimPattern()
	call VUAssertEquals(0, match('!', '\v'.HowmEscapeVimPattern('!')), '「!」のエスケープ')
  call VUAssertEquals(0, match('@', '\v'.HowmEscapeVimPattern('@')), '「@」のエスケープ')
  call VUAssertEquals(0, match('#', '\v'.HowmEscapeVimPattern('#')), '「#」のエスケープ')
  call VUAssertEquals(0, match('$', '\v'.HowmEscapeVimPattern('$')), '「$」のエスケープ')
  call VUAssertEquals(0, match('%', '\v'.HowmEscapeVimPattern('%')), '「%」のエスケープ')
  call VUAssertEquals(0, match('^', '\v'.HowmEscapeVimPattern('^')), '「^」のエスケープ')
  call VUAssertEquals(0, match('&', '\v'.HowmEscapeVimPattern('&')), '「&」のエスケープ')
  call VUAssertEquals(0, match('*', '\v'.HowmEscapeVimPattern('*')), '「*」のエスケープ')
  call VUAssertEquals(0, match('()', '\v'.HowmEscapeVimPattern('()')), '「()」のエスケープ')
  call VUAssertEquals(0, match('_', '\v'.HowmEscapeVimPattern('_')), '「_」のエスケープ')
  call VUAssertEquals(0, match('+', '\v'.HowmEscapeVimPattern('+')), '「+」のエスケープ')
  call VUAssertEquals(0, match('|', '\v'.HowmEscapeVimPattern('|')), '「|」のエスケープ')
  call VUAssertEquals(0, match('-', '\v'.HowmEscapeVimPattern('-')), '「-」のエスケープ')
  call VUAssertEquals(0, match('=', '\v'.HowmEscapeVimPattern('=')), '「=」のエスケープ')
  call VUAssertEquals(0, match('{}', '\v'.HowmEscapeVimPattern('{}')), '「{}」のエスケープ')
  call VUAssertEquals(0, match(':', '\v'.HowmEscapeVimPattern(':')), '「:」のエスケープ')
  call VUAssertEquals(0, match('"', '\v'.HowmEscapeVimPattern('"')), '「"」のエスケープ')
  call VUAssertEquals(0, match('<>', '\v'.HowmEscapeVimPattern('<>')), '「<>」のエスケープ')
  call VUAssertEquals(0, match('?', '\v'.HowmEscapeVimPattern('?')), '「?」のエスケープ')
  call VUAssertEquals(0, match('[]', '\v'.HowmEscapeVimPattern('[]')), '「[]」のエスケープ')
  call VUAssertEquals(0, match(';', '\v'.HowmEscapeVimPattern(';')), '「;」のエスケープ')
  call VUAssertEquals(0, match('\', '\v'.HowmEscapeVimPattern('\')), '「\」のエスケープ')
  call VUAssertEquals(0, match(',', '\v'.HowmEscapeVimPattern(',')), '「,」のエスケープ')
  call VUAssertEquals(0, match('.', '\v'.HowmEscapeVimPattern('.')), '「.」のエスケープ')
  call VUAssertEquals(0, match('/', '\v'.HowmEscapeVimPattern('/')), '「/」のエスケープ')
  call VUAssertEquals(0, match('~', '\v'.HowmEscapeVimPattern('~')), '「~」のエスケープ')
  call VUAssertEquals(0, match('!@#$%^&*()_+|-={}:"<>?[];\,./~', '\v'.HowmEscapeVimPattern('!@#$%^&*()_+|-={}:"<>?[];\,./~')), '「全記号」のエスケープ')
endfunction

endif
" 単体テスト用関数 }}}

" vim:set ts=2 sts=2 sw=2 tw=0 fdm=marker:
