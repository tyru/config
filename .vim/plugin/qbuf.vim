if v:version < 700
	finish
endif

if !exists("g:qb_hotkey") || g:qb_hotkey == ""
	let g:qb_hotkey = "<F4>"
endif
exe "nnoremap <unique>" g:qb_hotkey " :cal <SID>init(1)<cr>:cal SBRun()<cr>"
exe "cnoremap <unique>" g:qb_hotkey "<Esc>"

if exists("g:qb_loaded") && g:qb_loaded
	finish
endif
let g:qb_loaded = 1

let s:action2cmd = {"z": 'call <SID>switchbuf(#,"")', "!z": 'call <SID>switchbuf(#,"!")',
			\"u": "hid b #|let s:cursel = (s:cursel+1) % s:blen",
			\"s": "sb #",
			\"d": 'call <SID>qbufdcmd(#,"")', "!d": 'call <SID>qbufdcmd(#,"!")',
			\"w": "bw #", "!w": "bw! #",
			\"l": "let s:unlisted = 1 - s:unlisted",
			\"c": 'call <SID>closewindow(#,"")'}

function s:rebuild()
	redir @y | silent ls! | redir END
	let s:buflist = []
	let s:blen = 0

	for l:theline in split(@y,"\n")
		if s:unlisted && l:theline[3] == "u" && (l:theline[6] != "-" || l:theline[5] != " ")
					\ || !s:unlisted && l:theline[3] != "u"
			if s:unlisted
				let l:moreinfo = substitute(l:theline[5], "[ah]", " [+]", "")
			else
				let l:moreinfo = substitute(l:theline[7], "+", " [+]", "")
			endif
			let s:blen += 1
			let l:fname = matchstr(l:theline, '"\zs[^"]*')
			let l:bufnum = matchstr(l:theline, '^ *\zs\d*')

			if l:bufnum == bufnr('')
				let l:active = '* '
			elseif bufwinnr(str2nr(l:bufnum)) > 0
				let l:active = '= '
			else
				let l:active = '  '
			endif

			call add(s:buflist, s:blen . l:active
				\.fnamemodify(l:fname,":t") . l:moreinfo
				\." <" . l:bufnum . "> "
				\.fnamemodify(l:fname,":h"))
		endif
	endfor

	let l:alignsize = max(map(copy(s:buflist),'stridx(v:val,">")'))
	call map(s:buflist, 'substitute(v:val, " <", repeat(" ",l:alignsize-stridx(v:val,">"))." <", "")')
	call map(s:buflist, 'strpart(v:val, 0, &columns-3)')
endfunc

function SBRun()
	if !exists("s:cursel") || (s:cursel >= s:blen) || (s:cursel < 0)
		let s:cursel = s:blen-1
	endif

	if s:blen < 1
		echoh WarningMsg | echo "No" s:unlisted ? "unlisted" : "listed" "buffer!" | echoh None
		call s:init(0)
		return
	endif
	for l:idx in range(s:blen)
		if l:idx != s:cursel
			echo "  " . s:buflist[l:idx]
		else
			echoh DiffText | echo "> " . s:buflist[l:idx] | echoh None
		endif
	endfor

	if s:unlisted
		echoh WarningMsg
	endif
	let l:pkey = input(s:unlisted ? "UNLISTED ([+] loaded):" : "LISTED ([+] modified):" , " ")
	if s:unlisted
		echoh None
	endif
	if l:pkey =~ "j$"
		let s:cursel = (s:cursel+1) % s:blen
	elseif l:pkey =~ "k$"
		if s:cursel == 0
			let s:cursel = s:blen - 1
		else
			let s:cursel -= 1
		endif
	elseif s:update_buf(l:pkey)
		call s:init(0)
		return
	endif
	call s:setcmdh(s:blen+1)
endfunc

function s:init(onStart)
	if a:onStart
		set nolazyredraw
		let s:unlisted = 1 - getbufvar("%", "&buflisted")
		let s:cursorbg = synIDattr(hlID("Cursor"),"bg")
		let s:cursorfg = synIDattr(hlID("Cursor"),"fg")
		let s:cmdh = &cmdheight
		hi Cursor guibg=NONE guifg=NONE

		let s:klist = ["j", "k", "u", "d", "w", "l", "s", "c"]
		for l:key in s:klist
			exe "cnoremap ".l:key." ".l:key."<cr>:cal SBRun()<cr>"
		endfor
		cmap <up> k
		cmap <down> j

		call s:rebuild()
		let s:cursel = match(s:buflist, '^\d*\*')
		call s:setcmdh(s:blen+1)
	else
		call s:setcmdh(s:cmdh)
		for l:key in s:klist
			exe "cunmap ".l:key
		endfor
		cunmap <up>
		cunmap <down>
		exe "hi Cursor guibg=" . s:cursorbg . " guifg=".((s:cursorfg == "") ? "NONE" : s:cursorfg)
	endif
endfunc

" return true to indicate termination
function s:update_buf(cmd)
	if a:cmd != "" && a:cmd =~ '^ *\d*!\?\a\?$'
		let l:bufidx = str2nr(a:cmd) - 1
		if l:bufidx == -1
			let l:bufidx = s:cursel
		endif

		let l:action = matchstr(a:cmd, '!\?\a\?$')
		if l:action == "" || l:action == "!"
			let l:action .= "z"
		endif

		if l:bufidx >= 0 && l:bufidx < s:blen && has_key(s:action2cmd, l:action)
			try
				exe substitute(s:action2cmd[l:action], "#", matchstr(s:buflist[l:bufidx], '<\zs\d\+\ze>'), "g")
				if l:action[-1:] != "z"
					call s:rebuild()
				endif
			catch
				echoh ErrorMsg | echo "\rVIM" matchstr(v:exception, '^Vim(\a*):\zs.*') | echoh None
				if l:action[-1:] != "z"
					call inputsave() | call getchar() | call inputrestore()
				endif
			endtry
		endif
	endif
	return index(s:klist, a:cmd[-1:]) == -1
endfunc

function s:setcmdh(height)
	if a:height > &lines - winnr('$') * (&winminheight+1) - 1
		call s:init(0)
		echo "\r"|echoerr "QBuf E1: No room to display buffer list"
	else
		exe "set cmdheight=".a:height
	endif
endfunc

function s:switchbuf(bno, mod)
	if bufwinnr(a:bno) == -1
		exe "b".a:mod a:bno
	else
		exe bufwinnr(a:bno) . "winc w"
	endif
endfunc

function s:qbufdcmd(bno, mod)
	if s:unlisted
		call setbufvar(a:bno, "&buflisted", 1)
	else
		exe "bd" . a:mod a:bno
	endif
endfunc

function s:closewindow(bno, mod)
	if bufwinnr(a:bno) != -1
		exe bufwinnr(a:bno) . "winc w|close" . a:mod
	endif
endfunc
