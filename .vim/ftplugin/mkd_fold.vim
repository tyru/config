setlocal foldmethod=expr
setlocal foldexpr=MarkdownFold()

function! MarkdownFold()
  let head = s:head(v:lnum)
  if head
    return head
  elseif v:lnum != line('$') && getline(v:lnum + 1) =~ '^#'
    return '<' . s:head(v:lnum + 1)
  endif
  return '='
endfunction

function! s:head(lnum)
  return strlen(matchstr(getline(a:lnum), '^#*'))
endfunction

