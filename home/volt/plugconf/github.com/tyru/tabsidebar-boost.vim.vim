" vim:et:sw=2:ts=2

function! s:on_load_pre()
  if !has('tabsidebar')
    return
  endif

  nmap     <Space><Space>  <Plug>(tabsidebar-boost-jump)
  nmap     <C-n>           <Plug>(tabsidebar-boost-next-window)
  nmap     <C-p>           <Plug>(tabsidebar-boost-previous-window)
  nnoremap <Space>t        :<C-u>TabSideBarBoostSetTitle<Space><C-r>=get(t:, 'tabsidebar_boost_title', '')<CR>

  let g:tabsidebar_boost#auto_adjust_tabsidebarcolumns = 1

  let &g:tabsidebar = '%!tabsidebar_boost#tabsidebar(g:actual_curtabpage)'
endfunction

function! s:on_load_post()
  " Plugin configuration like the code written in vimrc.
  " This configuration is executed *after* a plugin is loaded.
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
