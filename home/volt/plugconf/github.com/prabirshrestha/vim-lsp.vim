" vim:et:sw=2:ts=2

" Plugin configuration like the code written in vimrc.
" This configuration is executed *before* a plugin is loaded.
function! s:on_load_pre()
  let g:lsp_highlight_references_enabled = 0

  " https://github.com/prabirshrestha/vim-lsp/wiki
  augroup vimrc-lsp
    autocmd!
    " efm-langserver
    if 0 && executable('efm-langserver')
      autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'efm-langserver',
        \ 'cmd': {server_info->['efm-langserver', '-c=/path/to/your/config.yaml']},
        \ 'whitelist': ['vim', 'markdown'],
        \ })
    endif
    " gopls
    if 1 && executable('gopls')
      autocmd User lsp_setup call lsp#register_server({
      \ 'name': 'gopls',
      \ 'cmd': {server_info->['gopls']},
      \ 'whitelist': ['go'],
      "\ https://github.com/golang/tools/blob/master/gopls/doc/settings.md
      \ 'workspace_config': {'gopls': {
      \     'staticcheck': v:true,
      \     'completeUnimported': v:true,
      \     'usePlaceholders': v:true,
      \   }},
      \ })
      autocmd FileType go setlocal omnifunc=lsp#complete
      autocmd FileType go nmap <buffer> <C-]> <plug>(lsp-definition)
      autocmd FileType go autocmd vimrc-lsp BufWritePre <buffer> silent LspDocumentFormatSync
    endif
    " typescript-language-server
    if 1 && executable('typescript-language-server')
      autocmd User lsp_setup call lsp#register_server({
          \ 'name': 'typescript-language-server',
          \ 'cmd': {server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
          \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'tsconfig.json'))},
          \ 'whitelist': ['typescript', 'typescript.tsx'],
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