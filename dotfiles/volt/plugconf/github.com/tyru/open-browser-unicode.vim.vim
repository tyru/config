function! s:config()
  " Plugin configuration like the code written in vimrc.
endfunction

function! s:loaded_on()
  return 'excmd=OpenBrowserUnicode'
endfunction

function! s:depends()
  return ['github.com/tyru/open-browser.vim']
endfunction
