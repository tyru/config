
let s:is_win = has('win16') || has('win32') || has('win64') || has('win95')

function! vimrc#cmd_expand#call(args)
  if a:args != ''
    let str = expand(a:args)
  else
    if getbufvar('%', '&buftype') == ''
      let str = expand('%:p')
    else
      let str = expand('%')
    endif
  endif
  if s:is_win
    let str = tr(str, '/', '\')
  endif
  echo str
  let [@", @+, @*] = [str, str, str]
endfunction
