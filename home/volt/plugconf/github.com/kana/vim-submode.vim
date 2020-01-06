" vim:et:sw=2:ts=2:fdm=marker

" Plugin configuration like the code written in vimrc.
" This configuration is executed *before* a plugin is loaded.
function! s:on_load_pre()
endfunction

" Plugin configuration like the code written in vimrc.
" This configuration is executed *after* a plugin is loaded.
function! s:on_load_post()
  " winsize {{{1
  call submode#enter_with('winsize', 'n', '', '<C-w>>', '<C-w>>')
  call submode#enter_with('winsize', 'n', '', '<C-w><', '<C-w><')
  call submode#enter_with('winsize', 'n', '', '<C-w>+', '<C-w>+')
  call submode#enter_with('winsize', 'n', '', '<C-w>-', '<C-w>-')

  call submode#map('winsize', 'n', '', '>', '<C-w>>')
  call submode#map('winsize', 'n', '', '<', '<C-w><')
  call submode#map('winsize', 'n', '', '+', '<C-w>+')
  call submode#map('winsize', 'n', '', '-', '<C-w>-')

  " winjump {{{1
  if 0

  function! s:winjump_options() abort
    return ''
  endfunction
  function! s:winjump_rhs(dir) abort
    return '<C-w>' . a:dir
  endfunction

  nmap <Space>j <C-w>j
  nmap <Space>k <C-w>k
  nmap <Space>h <C-w>h
  nmap <Space>l <C-w>l

  nmap <C-w><C-j> <C-w>j
  nmap <C-w><C-k> <C-w>k
  nmap <C-w><C-h> <C-w>h
  nmap <C-w><C-l> <C-w>l

  call submode#enter_with('winjump', 'n', s:winjump_options(), '<C-w>j', s:winjump_rhs('j'))
  call submode#enter_with('winjump', 'n', s:winjump_options(), '<C-w>k', s:winjump_rhs('k'))
  call submode#enter_with('winjump', 'n', s:winjump_options(), '<C-w>h', s:winjump_rhs('h'))
  call submode#enter_with('winjump', 'n', s:winjump_options(), '<C-w>l', s:winjump_rhs('l'))

  call submode#map('winjump', 'n', 'r', '<Space>j', 'j')
  call submode#map('winjump', 'n', 'r', '<Space>k', 'k')
  call submode#map('winjump', 'n', 'r', '<Space>h', 'h')
  call submode#map('winjump', 'n', 'r', '<Space>l', 'l')

  call submode#map('winjump', 'n', 'r', '<C-w><C-j>', 'j')
  call submode#map('winjump', 'n', 'r', '<C-w><C-k>', 'k')
  call submode#map('winjump', 'n', 'r', '<C-w><C-h>', 'h')
  call submode#map('winjump', 'n', 'r', '<C-w><C-l>', 'l')

  call submode#map('winjump', 'n', 'r', '<C-w>j', 'j')
  call submode#map('winjump', 'n', 'r', '<C-w>k', 'k')
  call submode#map('winjump', 'n', 'r', '<C-w>h', 'h')
  call submode#map('winjump', 'n', 'r', '<C-w>l', 'l')

  call submode#map('winjump', 'n', s:winjump_options(), 'j', s:winjump_rhs('j'))
  call submode#map('winjump', 'n', s:winjump_options(), 'k', s:winjump_rhs('k'))
  call submode#map('winjump', 'n', s:winjump_options(), 'h', s:winjump_rhs('h'))
  call submode#map('winjump', 'n', s:winjump_options(), 'l', s:winjump_rhs('l'))

  endif
  " }}}
endfunction

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
function! s:loaded_on()
  return 'start'
endfunction

" Dependencies of this plugin.
" The specified dependencies are loaded after this plugin is loaded.
"
" This function must contain 'return [<repos>, ...]' code.
" (the argument of :return must be list literal, and the elements are string)
" e.g. return ['github.com/tyru/open-browser.vim']
function! s:depends()
  return []
endfunction