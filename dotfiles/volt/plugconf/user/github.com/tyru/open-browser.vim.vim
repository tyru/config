
function! s:config()
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
