let s:config = vivo#plugconf#new()

function! s:config.config()
  xmap <Plug>(vimrc:prefix:operator)cy <Plug>(operator-concealedyank)
  " concealedyank.vim does not support operator yet.
  " nmap y <Plug>(operator-concealedyank)
  " omap y <Plug>(operator-concealedyank)
endfunction
