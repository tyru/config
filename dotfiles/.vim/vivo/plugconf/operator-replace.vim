let s:config = vivo#plugconf#new()

function! s:config.config()
  nmap <Plug>(vimrc:prefix:operator)p <Plug>(operator-replace)
  xmap <Plug>(vimrc:prefix:operator)p <Plug>(operator-replace)
  omap <Plug>(vimrc:prefix:operator)p <Plug>(operator-replace)
endfunction
