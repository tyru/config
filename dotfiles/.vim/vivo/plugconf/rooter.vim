let s:config = vivo#plugconf#new()

function! s:config.config()
    Map [n] <excmd>cd :<C-u>Rooter<CR>

    let g:rooter_disable_map = 1
    let g:rooter_manual_only = 1
    " let g:rooter_use_lcd = 1
    let g:rooter_change_directory_for_non_project_files = 1
    " let g:rooter_silent_chdir = 1
endfunction
