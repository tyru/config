let s:config = vivo#plugconf#new()

function! s:config.config()
  nmap <Plug>(vimrc:prefix:operator)rl <Plug>(operator-reverse-lines)
  xmap <Plug>(vimrc:prefix:operator)rl <Plug>(operator-reverse-lines)
  omap <Plug>(vimrc:prefix:operator)rl <Plug>(operator-reverse-lines)

  nmap <Plug>(vimrc:prefix:operator)rw <Plug>(operator-reverse-text)
  xmap <Plug>(vimrc:prefix:operator)rw <Plug>(operator-reverse-text)
  omap <Plug>(vimrc:prefix:operator)rw <Plug>(operator-reverse-text)
endfunction
