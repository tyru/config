" vim:et:sw=2:ts=2

function! s:on_load_pre()
  " Plugin configuration like the code written in vimrc.
  " This configuration is executed *before* a plugin is loaded.

  if get(g:, 'loaded_tabsidebar_boost')
    let g:ws#script_template = 'GenerateScript'
  endif
endfunction

function! GenerateScript(param) abort
  let repos = s:canonpath($VOLTPATH ? $VOLTPATH : expand('~/volt') . '/repos')
  let dir = s:canonpath(a:param.dir)
  let relpath = substitute(dir, '^\V' . repos . '/', '', '')
  if relpath ==# dir
    return ws#generate_script(a:param)
  endif
  let name = substitute(relpath, '^github\.com/', '', '')
  return ws#generate_script(a:param) + ['TabSideBarBoostSetTitle ' . name]
endfunction

function! s:canonpath(path) abort
  return substitute(fnamemodify(resolve(a:path), ':p'), '/$', '', '')
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

  return ['github.com/tyru/tabsidebar-boost.vim']
endfunction