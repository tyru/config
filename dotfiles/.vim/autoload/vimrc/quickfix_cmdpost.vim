
function! vimrc#quickfix_cmdpost#call(local) abort
  if !empty(a:local ? getloclist(0) : getqflist())
    execute a:local ? 'lopen' : 'copen'
  else
    execute a:local ? 'lclose' : 'cclose'
    echohl ErrorMsg
    echo 'No items found'
    echohl None
  endif
endfunction
