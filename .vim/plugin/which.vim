"=============================================================================
" File: which.vim
" Author: Yasuhiro Matsumoto <mattn_jp@hotmail.com>
" Last Change:	Thu, 15 Nov 2001
" Version: 1.0
" Thanks:
" ChangeLog:
"     1.0  : first release
" Usage:
"     :echo Which("wget")
"       echo the found path from given argument

function! s:GetToken(src,dlm,cnt)
  let tokn_hit=0     " flag of found
  let tokn_fnd=''    " found path
  let tokn_spl=''    " token
  let tokn_all=a:src " all source

  let tokn_all = tokn_all.a:dlm
  while 1
    let tokn_spl = strpart(tokn_all,0,match(tokn_all,a:dlm))
    if tokn_spl == ''
	  break
    endif
    let tokn_hit = tokn_hit + 1
	if tokn_hit == a:cnt
      return tokn_spl
	endif
    let tokn_all = strpart(tokn_all,strlen(tokn_spl.a:dlm))
  endwhile
  return ''
endfunction

function! Which(file_arg)
  let path_env = $PATH    " PATH environment
  let path_tok = ''       " token for PATH
  let path_num = 1        " count of token for PATH
  let pext_env = $PATHEXT " PATHEXT environment
  let pext_tok = ''       " token for PATHEXT
  let pext_num = 1        " count of token for PATHEXT

  let delm_chr = ':'      " separator of PATH environment
  let sepa_chr = '/'      " separator of path
  let glob_ret = ''       " for work

  " for win32
  if has('win32') && match(path_env,';')
    let delm_chr = ';'
    let sepa_chr = '\\'
  endif

  while 1
    let path_tok = s:GetToken(path_env, delm_chr, path_num)
    if path_tok == ''
	  break
    endif
    if matchend(path_tok,sepa_chr) == -1
      let path_tok = path_tok . sepa_chr
    endif
	if pext_env != ''
	  let pext_num = 1
      while 1
		let pext_tok = s:GetToken(pext_env, delm_chr, pext_num)
	    let glob_ret = globpath(path_tok,a:file_arg.pext_tok)
		if pext_tok == '' || glob_ret != ''
		  break
		endif
	    let pext_num = pext_num + 1
	  endwhile
	else
	  let glob_ret = globpath(path_tok,a:file_arg)
	endif
    if glob_ret != ''
      if delm_chr == ';'
        let glob_ret = substitute(glob_ret, '/', '\\', 'g')
      endif
	  return glob_ret
    endif
	let path_num = path_num + 1
  endwhile
  return ''
endfunction
