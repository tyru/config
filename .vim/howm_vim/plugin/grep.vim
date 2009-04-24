"
" grep.vim - grep の Vim Script による実装．
"
" Last Change: 04-Jun-2006.
" Written By: Kouichi NANASHIMA <claymoremine@anet.ne.jp>

scriptencoding euc-jp

" ひとまず HInr 準拠で…
function! GrepSearch(searchWord, searchPath, options)
  let searchWord = escape(a:searchWord, "~@=")
  if a:options =~ "\\CF"
    let searchWord = "\\V".escape(searchWord, "\\")
  else
    let searchWord = "\\v".searchWord
  endif
  if a:options !~ "\\Ci"
    let searchWord = "\\C".searchWord
  endif

  silent! new
  silent! setlocal bt=nofile bh=delete noswf binary
  let pathList = strpart(a:searchPath, match(a:searchPath, "\\S"))
  let idx = match(pathList, "\\s")
  if idx != -1
    let file = strpart(pathList, 0, idx)
    let pathList = strpart(pathList, idx)
  else
    let file = pathList
    let pathList = ""
  endif
  let retval = ""
  while file != ""
    let file = expand(file)
    if isdirectory(file)
      if file !~ "[\\/]$"
        let file = file."/"
      endif
      let file = file."*"
      let file = substitute(expand(file), "\<NL>", " ", "g")
      let pathList = file." ".pathList
    elseif filereadable(file)
      if has('win32') && substitute(file, '.*\.\(.\{-}\)', '\1', '') == 'lnk'
        " Win32 のショートカットを追うための処理
        silent! exe "new ".file
        let linkto = expand("%:p")
        silent! close
        if file != linkto
          let file = linkto
          continue
        endif
      endif
      silent! exe "$r ".file
      silent! 1delete _
			let retval = retval.GrepBuffer(searchWord, file, 1, 1)
      silent! g/^/d
    endif
    let pathList = strpart(pathList, match(pathList, "\\S"))
    let idx = match(pathList, "\\s")
    if idx != -1
      let file = strpart(pathList, 0, idx)
      let pathList = strpart(pathList, idx)
    else
      let file = pathList
      let pathList = ""
    endif
  endwhile
  silent! close

  return retval
endfunction

" 現在開いているバッファ内を検索し、
" searchWord が含まれている行を抽出する。
" ファイル表示フラグ、行番号表示フラグが 0 以外の場合は
" 検索結果にそれぞれ検索ファイルと行番号を表示する。
"
" - searchWord 検索語
" - file 検索ファイル（検索結果に表示）
" - bFile ファイル表示フラグ
" - bLine 行番号表示フラグ
" 
" - return 検索結果
function! GrepBuffer(searchWord, file, bFile, bLine)
	let retval = ''
	call cursor(1, 1)
	if getline(1) =~ a:searchWord
		let line = 1
	else
		let line = search(a:searchWord, "W")
	endif
	while line != 0
		let retLine = ''
		" 行番号追加
		if a:bFile
			let retLine = retLine.substitute(a:file, "\\\\", "/", "g").':'
		endif
		" 検索ファイル追加
		if a:bLine
			let retLine = retLine.line.':'
		endif
		let retLine = retLine.getline(line)."\<NL>"
		let retval = retval.retLine
		silent! normal! $
		let line = search(a:searchWord, "W")
	endwhile
	return retval
endfunction
