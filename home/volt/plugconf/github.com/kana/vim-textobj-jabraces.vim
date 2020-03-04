" vim:et:sw=2:ts=2

function! s:on_load_pre()
  " Using this plugin from vim-textobj-multitextobj.
  " See ~/volt/plugconf/github.com/osyo-manga/vim-textobj-multitextobj.vim
  let g:textobj_jabraces_no_default_key_mappings = 1
endfunction

" Plugin configuration like the code written in vimrc.
" This configuration is executed *after* a plugin is loaded.
function! s:on_load_post()
endfunction

function! s:loaded_on()
  return 'start'
endfunction

function! s:depends()
  return ['github.com/kana/vim-textobj-user']
endfunction