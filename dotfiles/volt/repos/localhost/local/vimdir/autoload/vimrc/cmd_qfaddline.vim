
function! vimrc#cmd_qfaddline#add() range
  for lnum in range(a:firstline, a:lastline)
    call s:quickfix_add_line(lnum)
  endfor
endfunction

function! s:quickfix_add_line(lnum)
  let lnum = a:lnum =~# '^\d\+$' ? a:lnum : line(a:lnum)
  let qf = {
  \   'bufnr': bufnr('%'),
  \   'lnum': lnum,
  \   'text': getline(lnum),
  \}
  if s:quickfix_supported_quickfix_title()
    " Set 'qf.col' and 'qf.vcol'.
    call s:quickfix_add_line_set_col(lnum, qf)
  endif
  call setqflist([qf], 'a')
endfunction

function! s:quickfix_add_line_set_col(lnum, qf)
  let lnum = a:lnum
  let qf = a:qf

  let search_word = s:quickfix_get_search_word()
  if search_word !=# ''
    let idx = match(getline(lnum), search_word[1:])
    if idx isnot -1
      let qf.col = idx + 1
      let qf.vcol = 0
    endif
  endif
endfunction

" Quickfix utility functions {{{
function! s:quickfix_get_winnr()
  " quickfix window is usually at bottom,
  " thus reverse-lookup.
  for winnr in reverse(range(1, winnr('$')))
    if getwinvar(winnr, '&buftype') ==# 'quickfix'
      return winnr
    endif
  endfor
  return 0
endfunction
function! s:quickfix_exists_window()
  return !!s:quickfix_get_winnr()
endfunction
function! s:quickfix_supported_quickfix_title()
  return v:version >=# 703
endfunction
function! s:quickfix_get_search_word()
  " NOTE: This function returns a string starting with "/"
  " if previous search word is found.
  " This function can't use an empty string
  " as a failure return value, because ":vimgrep /" also returns an empty string.

  " w:quickfix_title only works 7.3 or later.
  if !s:quickfix_supported_quickfix_title()
    return ''
  endif

  let qf_winnr = s:quickfix_get_winnr()
  if !qf_winnr
    copen
  endif

  try
    let qf_title = getwinvar(qf_winnr, 'quickfix_title')
    if qf_title ==# ''
      return ''
    endif

    " NOTE: Supported only :vim[grep] command.
    let rx = '^:\s*\<vim\%[grep]\>\s*\(/.*\)'
    let m = matchlist(qf_title, rx)
    if empty(m)
      return ''
    endif

    return m[1]
  finally
    if !qf_winnr
      cclose
    endif
  endtry
endfunction

" }}}
