" vim:et:sw=2:ts=2

" Plugin configuration like the code written in vimrc.
" This configuration is executed *before* a plugin is loaded.
function! s:on_load_pre()
  let g:lsp_highlight_references_enabled = 0

  function! s:common_settings() abort
    setlocal omnifunc=lsp#complete
    nmap <buffer> <C-]> <plug>(lsp-definition)
  endfunction

  " cf.
  " - https://github.com/prabirshrestha/vim-lsp/wiki
  " - ~/config/home/volt/plugconf/github.com/mattn/vim-lsp-settings.vim
  augroup vimrc-lsp
    autocmd!
    " gopls
    if executable('gopls')
      autocmd FileType go call s:common_settings()
      autocmd FileType go autocmd BufWritePre <buffer> silent LspDocumentFormatSync
    endif
    " typescript-language-server
    if executable('typescript-language-server')
      autocmd FileType typescript,typescript.tsx,javascript,javascript.jsx
        \ call s:common_settings()
    endif
    " metals-vim
    if executable('metals-vim')
      autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'metals',
        \ 'cmd': {server_info->['metals-vim']},
        \ 'initialization_options': { 'rootPatterns': 'build.sbt' },
        \ 'whitelist': [ 'scala', 'sbt' ],
        \ })
      autocmd FileType scala,sbt call s:common_settings()
    endif
    " pyls
    if executable('pyls')
      autocmd FileType python call s:common_settings()
    endif
  augroup END
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
  return []
endfunction