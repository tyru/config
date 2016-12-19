let s:config = vivo#plugconf#new()

function! s:config.config()
    let g:neocomplete#enable_at_startup = 1
    let g:neocomplete#disable_auto_complete = 1
    let g:neocomplete#enable_ignore_case = 1
    let g:neocomplete#enable_smart_case = 1
    let g:neocomplete#auto_completion_start_length = 3
    let g:neocomplete#max_list = 30

    nnoremap <Leader>neo :<C-u>NeoCompleteToggle<CR>

    inoremap <expr> <C-y> neocomplete#close_popup()
    inoremap <expr> <CR> pumvisible() ? neocomplete#close_popup() . "\<CR>" : "\<CR>"
    imap <C-t> <Plug>(neocomplete_snippets_expand)
    smap <C-t> <Plug>(neocomplete_snippets_expand)
endfunction
