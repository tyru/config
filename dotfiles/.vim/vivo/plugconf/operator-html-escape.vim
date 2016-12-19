let s:config = vivo#plugconf#new()

function! s:config.config()
  nmap <Plug>(vimrc:prefix:operator)he <Plug>(operator-html-escape)
  xmap <Plug>(vimrc:prefix:operator)he <Plug>(operator-html-escape)
  omap <Plug>(vimrc:prefix:operator)he <Plug>(operator-html-escape)

  nmap <Plug>(vimrc:prefix:operator)hu <Plug>(operator-html-unescape)
  xmap <Plug>(vimrc:prefix:operator)hu <Plug>(operator-html-unescape)
  omap <Plug>(vimrc:prefix:operator)hu <Plug>(operator-html-unescape)
endfunction
