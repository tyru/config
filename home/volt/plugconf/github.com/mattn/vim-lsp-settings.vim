" vim:et:sw=2:ts=2

function! s:on_load_pre()
  let g:lsp_settings_servers_dir = expand('$HOME/.local/share/vim-lsp-settings/servers')
  let g:lsp_settings = {
    \ 'gopls': {'workspace_config': {
    \     'staticcheck': v:true,
    \     'completeUnimported': v:true,
    \     'usePlaceholders': v:true,
    \   }},
    \ 'typescript-language-server': {
    \     'whitelist': ['typescript', 'typescript.tsx', 'javascript', 'javascript.jsx']
    \   },
    \}
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