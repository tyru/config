" vim:et:sw=2:ts=2

function! s:on_load_pre()
  let g:qfloc_disable_sign = 1
  let g:qfloc_disable_hover = 1
  let g:qfloc#motion#wrap = 0
  let g:qfloc#jump#wrap = 0
  nmap <CR> <Plug>(qfloc-sbuffer)
endfunction

" Plugin configuration like the code written in vimrc.
" This configuration is executed *after* a plugin is loaded.
function! s:on_load_post()
endfunction

function! s:loaded_on()
  return 'start'
endfunction

function! s:depends()
  return []
endfunction