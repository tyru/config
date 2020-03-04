" vim:et:sw=2:ts=2

function! s:on_load_pre()
  let g:nf_ignore_ext = ['o', 'obj', 'exe', 'bin']

  " g:nf_loop_hook_fn only works when g:nf_loop_files is true.
  let g:nf_loop_files = 1
  " Call this function when wrap around.
  " let g:nf_loop_hook_fn = 'NFLoopPrompt'
  let g:nf_loop_hook_fn = 'NFLoopMsg'
  " To avoid |hit-enter| for NFLoopMsg().
  let g:nf_open_command = 'silent edit'
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

function! NFLoopMsg(file_to_open)
  redraw
  echohl WarningMsg
  echomsg 'open a file from the start...'
  echohl None
  " Always open a next/previous file...
  return 1
endfunction

function! NFLoopPrompt(file_to_open)
  return input('open a file from the start? [y/n]:') =~? 'y\%[es]'
endfunction