" vim:et:sw=2:ts=2

function! s:on_load_pre()
  let g:lsp_highlight_references_enabled = 0
  let g:lsp_signature_help_enabled = 0
  let g:lsp_semantic_enabled = 0
  let g:lsp_log_file = expand('~/vim-lsp.log')
  " let g:lsp_async_completion = 1
  let g:lsp_diagnostics_float_cursor = 0
  let g:lsp_diagnostics_echo_cursor = 1

  function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    nmap <buffer> <C-]> <plug>(lsp-definition)
  endfunction

  augroup lsp_install
    autocmd!
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
  augroup END
endfunction

" Plugin configuration like the code written in vimrc.
" This configuration is executed *after* a plugin is loaded.
function! s:on_load_post()
endfunction

function! s:loaded_on()
  return 'start'
endfunction

function! s:depends()
  return []
endfunction

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    nmap <buffer> <C-]> <plug>(lsp-definition)
  endfunction