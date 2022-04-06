" vim:et:sw=2:ts=2

" Plugin configuration like the code written in vimrc.
" This configuration is executed *before* a plugin is loaded.
function! s:on_load_pre()
  nmap <Space>m <Plug>(quickhl-manual-this)
  xmap <Space>m <Plug>(quickhl-manual-this)
  nmap <Space>M <Plug>(quickhl-manual-reset)
  xmap <Space>M <Plug>(quickhl-manual-reset)

  " the first color is unreadable on colorscheme seoul256
  let g:quickhl_manual_colors = [
  \ "cterm=bold ctermfg=7  ctermbg=1   gui=bold guibg=#a07040 guifg=#ffffff",
  \ "cterm=bold ctermfg=7  ctermbg=2   gui=bold guibg=#4070a0 guifg=#ffffff",
  \ "cterm=bold ctermfg=7  ctermbg=3   gui=bold guibg=#40a070 guifg=#ffffff",
  \ "cterm=bold ctermfg=7  ctermbg=4   gui=bold guibg=#70a040 guifg=#ffffff",
  \ "cterm=bold ctermfg=7  ctermbg=5   gui=bold guibg=#0070e0 guifg=#ffffff",
  \ "cterm=bold ctermfg=7  ctermbg=6   gui=bold guibg=#007020 guifg=#ffffff",
  \ "cterm=bold ctermfg=7  ctermbg=21  gui=bold guibg=#d4a00d guifg=#ffffff",
  \ "cterm=bold ctermfg=7  ctermbg=22  gui=bold guibg=#06287e guifg=#ffffff",
  \ "cterm=bold ctermfg=7  ctermbg=45  gui=bold guibg=#5b3674 guifg=#ffffff",
  \ "cterm=bold ctermfg=7  ctermbg=16  gui=bold guibg=#4c8f2f guifg=#ffffff",
  \ "cterm=bold ctermfg=7  ctermbg=50  gui=bold guibg=#1060a0 guifg=#ffffff",
  \ "cterm=bold ctermfg=7  ctermbg=56  gui=bold guibg=#a0b0c0 guifg=black",
  \ ]
endfunction

" Plugin configuration like the code written in vimrc.
" This configuration is executed *after* a plugin is loaded.
function! s:on_load_post()
endfunction

" Whether to actually load this plugin.
" Return a 0 value to prohibit loading the plugin. All other numbers mean
" this plugin will be loaded.
function! s:should_load()
  return 1
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