" vim:et:sw=2:ts=2

" Plugin configuration like the code written in vimrc.
" This configuration is executed *before* a plugin is loaded.
function! s:on_load_pre()
  nnoremap gA :<C-u>OpenBrowserUnicode<CR>
endfunction

" Plugin configuration like the code written in vimrc.
" This configuration is executed *after* a plugin is loaded.
function! s:on_load_post()
endfunction

function! s:loaded_on()
  " return 'excmd=OpenBrowserUnicode'
endfunction

function! s:depends()
  return ['github.com/tyru/open-browser.vim']
endfunction