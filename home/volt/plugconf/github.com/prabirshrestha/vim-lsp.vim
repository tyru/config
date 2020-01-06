" vim:et:sw=2:ts=2

" See also ~/config/home/volt/plugconf/github.com/mattn/vim-lsp-settings.vim
function! s:on_load_pre()
  let g:lsp_highlight_references_enabled = 0
  let g:lsp_signature_help_enabled = 0
  let g:lsp_semantic_enabled = 0
  let g:lsp_log_file = expand('~/vim-lsp.log')

  function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    nmap <buffer> <C-]> <plug>(lsp-definition)
  endfunction

  augroup lsp_install
    autocmd!
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
  augroup END

  " cf. https://github.com/prabirshrestha/vim-lsp/wiki
  " TODO: send pull request(s) to mattn/vim-lsp-settings
  augroup vimrc-lsp
    autocmd!
    " metals-vim
    if executable('metals-vim')
      autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'metals',
        \ 'cmd': {server_info->['metals-vim']},
        \ 'initialization_options': { 'rootPatterns': 'build.sbt' },
        \ 'whitelist': [ 'scala', 'sbt' ],
        \ })
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