let s:config = vivo#plugconf#new()

function! s:config.config()
  nmap <Plug>(vimrc:prefix:operator)c <Plug>(operator-camelize-toggle)
  xmap <Plug>(vimrc:prefix:operator)c <Plug>(operator-camelize-toggle)
  omap <Plug>(vimrc:prefix:operator)c <Plug>(operator-camelize-toggle)
  let g:operator_camelize_all_uppercase_action = 'camelize'
  let g:operator_decamelize_all_uppercase_action = 'lowercase'
endfunction
