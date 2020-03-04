" vim:et:sw=2:ts=2

function! s:on_load_pre()
  let g:disable_rainbow_hover = 1
  let g:disable_rainbow_csv_autodetect = 1
  augroup vimrc-rainbow_csv
    autocmd!
    " rfc_csv can treat multi-line record
    autocmd FileType csv setlocal filetype=rfc_csv
  augroup END
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