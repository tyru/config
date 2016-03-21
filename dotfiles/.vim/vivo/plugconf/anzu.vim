let s:config = vivo#plugconf#new()

function! s:config.config()
    autocmd vimrc VimEnter * Map -remap -force [nx] n <old-rhs><Plug>(anzu-update-search-status-with-echo)
    autocmd vimrc VimEnter * Map -remap -force [nx] N <old-rhs><Plug>(anzu-update-search-status-with-echo)
endfunction

