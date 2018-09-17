" vim:et:sw=2:ts=2

function! s:on_load_pre()
  let g:netrw_nogx = 1
  nmap gx <Plug>(openbrowser-smart-search)
  xmap gx <Plug>(openbrowser-smart-search)
  nmap goo <Plug>(openbrowser-open)
  xmap goo <Plug>(openbrowser-open)
  nmap gos <Plug>(openbrowser-search)
  xmap gos <Plug>(openbrowser-search)

  " let g:openbrowser_open_filepath_in_vim = 0
  if $VIMRC_USE_VIMPROC !=# 2
    let g:openbrowser_use_vimproc = $VIMRC_USE_VIMPROC
  endif
  " let g:openbrowser_force_foreground_after_open = 1

  command! OpenBrowserCurrent execute 'OpenBrowser' 'file://' . expand('%:p:gs?\\?/?')
endfunction

function! s:on_load_post()
  " Plugin configuration like the code written in vimrc.
  " This configuration is executed *after* a plugin is loaded.
endfunction

" function! s:loaded_on()
"   return 'excmd=OpenBrowser,OpenBrowserSearch,OpenBrowserSmartSearch'
" endfunction

function! s:depends()
  " Dependencies of this plugin.
  " The specified dependencies are loaded after this plugin is loaded.
  "
  " This function must contain 'return [<repos>, ...]' code.
  " (the argument of :return must be list literal, and the elements are string)
  " e.g. return ['github.com/tyru/open-browser.vim']

  return []
endfunction
