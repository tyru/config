"
" howm-search.vim - howm-mode.vim 用の検索処理ライブラリ
"
" Last Change: 04-Jun-2006.
" Written By: Kouichi NANASHIMA <claymoremine@anet.ne.jp>

scriptencoding euc-jp

let s:errmsg_noiconv = 'iconv が使えないので文字コードが変換できません'

function! HowmExecuteSearchPrg(cmd, prg, searchPath, searchWord, from_encoding, to_encoding)
  " iconv が使えないときの処理
  if a:from_encoding != a:to_encoding && !has('iconv')
    echoe s:errmsg_noiconv
    return
  endif

  let cmd = a:cmd

  " プログラム設定
  let cmd = substitute(cmd, '#prg#', escape(a:prg, '\\'), 'g')

  " 検索パス設定
  let cmd = substitute(cmd, '#searchPath#', escape(a:searchPath, '\\'), 'g')

  " 検索語設定
  let searchWord = a:searchWord
  if a:from_encoding != a:to_encoding
    let searchWord = iconv(searchWord, a:from_encoding, a:to_encoding)
  endif
  let cmd = substitute(cmd, '#searchWord#', searchWord, 'g')

  " 検索語ファイル作成
  if match(cmd, '#searchWordFile#') != -1
    let tempname = tempname()
    let opencmd = 'split'
    if a:from_encoding != a:to_encoding
      let opencmd = opencmd.' ++enc='.a:to_encoding
    endif
    let opencmd = opencmd.' '.tempname
    silent! exe opencmd
    unlet opencmd
    call setline(1, a:searchWord)
    silent! setlocal binary noendofline
    silent! w
    silent! bdelete
    let cmd = substitute(cmd, '#searchWordFile#', HowmEscapeVimPattern(tempname), 'g')
  endif

  " 検索コマンド実行
  call HowmDebugLog('HowmExecuteSearchPrg:Cmd='.cmd)
  let retval = system(cmd)

  " 検索語ファイル消去
  if exists('tempname')
    call delete(tempname)
  endif

  " 検索結果エンコード変換
  if a:from_encoding != a:to_encoding
    let retval = iconv(retval, a:to_encoding, a:from_encoding)
  endif
  " 検索結果改行コード変換
  let retval = substitute(retval, '\(\r\n\?\)', '\n', 'g')
  call HowmDebugLog('HowmExecuteSearchPrg:Retval='.retval)

  return retval
endfunction
