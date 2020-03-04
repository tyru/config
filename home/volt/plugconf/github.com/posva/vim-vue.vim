" vim:et:sw=2:ts=2

function! s:on_load_pre()
  nmap <Plug>(vimrc:prefix:excmd)ch <Plug>(closesubwin-close-help)
  nmap <Plug>(vimrc:prefix:excmd)cq <Plug>(closesubwin-close-quickfix)
  nmap <Plug>(vimrc:prefix:excmd)cu <Plug>(closesubwin-close-unlisted)
  " Close first matching window in above windows.
  nmap <Plug>(vimrc:prefix:excmd)cc <Plug>(closesubwin-close-sub)
endfunction

" Plugin configuration like the code written in vimrc.
" This configuration is executed *after* a plugin is loaded.
function! s:on_load_post()
endfunction

function! s:loaded_on()
  " This function determines when a plugin is loaded.
  "
  " Possible values are:
  " * 'start' (a plugin will be loaded at VimEnter event)
  " * 'filetype=<filetypes>' (a plugin will be loaded at FileType event)
  " * 'excmd=<excmds>' (a plugin will be loaded at CmdUndefined event)
  " <filetypes> and <excmds> can be multiple values separated by comma.
  "
  " This function must contain 'return "<str>"' code.
  " (the argument of :return must be string literal)

  return 'start'
endfunction

function! s:depends()
  " Dependencies of this plugin.
  " The specified dependencies are loaded after this plugin is loaded.
  "
  " This function must contain 'return [<repos>, ...]' code.
  " (the argument of :return must be list literal, and the elements are string)
  " e.g. return ['github.com/tyru/open-browser.vim']

  return []
endfunction