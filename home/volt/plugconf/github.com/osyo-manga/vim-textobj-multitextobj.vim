" vim:et:sw=2:ts=2

" Plugin configuration like the code written in vimrc.
" This configuration is executed *before* a plugin is loaded.
function! s:on_load_pre()
  let g:textobj_multitextobj_textobjects_i = [
    \ "\<Plug>(textobj-jabraces-parens-i)",
    \ "\<Plug>(textobj-jabraces-braces-i)",
    \ "\<Plug>(textobj-jabraces-brackets-i)",
    \ "\<Plug>(textobj-jabraces-angles-i)",
    \ "\<Plug>(textobj-jabraces-double-angles-i)",
    \ "\<Plug>(textobj-jabraces-kakko-i)",
    \ "\<Plug>(textobj-jabraces-double-kakko-i)",
    \ "\<Plug>(textobj-jabraces-yama-kakko-i)",
    \ "\<Plug>(textobj-jabraces-double-yama-kakko-i)",
    \ "\<Plug>(textobj-jabraces-kikkou-kakko-i)",
    \ "\<Plug>(textobj-jabraces-sumi-kakko-i)",
    \]
  let g:textobj_multitextobj_textobjects_a = [
    \ "\<Plug>(textobj-jabraces-parens-a)",
    \ "\<Plug>(textobj-jabraces-braces-a)",
    \ "\<Plug>(textobj-jabraces-brackets-a)",
    \ "\<Plug>(textobj-jabraces-angles-a)",
    \ "\<Plug>(textobj-jabraces-double-angles-a)",
    \ "\<Plug>(textobj-jabraces-kakko-a)",
    \ "\<Plug>(textobj-jabraces-double-kakko-a)",
    \ "\<Plug>(textobj-jabraces-yama-kakko-a)",
    \ "\<Plug>(textobj-jabraces-double-yama-kakko-a)",
    \ "\<Plug>(textobj-jabraces-kikkou-kakko-a)",
    \ "\<Plug>(textobj-jabraces-sumi-kakko-a)",
    \]
  omap ab <Plug>(textobj-multitextobj-a)
  omap ib <Plug>(textobj-multitextobj-i)
  vmap ab <Plug>(textobj-multitextobj-a)
  vmap ib <Plug>(textobj-multitextobj-i)
endfunction

" Plugin configuration like the code written in vimrc.
" This configuration is executed *after* a plugin is loaded.
function! s:on_load_post()
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
  return ['github.com/kana/vim-textobj-user']
endfunction