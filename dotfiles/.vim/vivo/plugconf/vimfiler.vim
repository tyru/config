let s:config = vivo#plugconf#new()

function! s:config.config()
    let g:vimfiler_as_default_explorer = 1
    let g:vimfiler_safe_mode_by_default = 0
    let g:vimfiler_split_command = 'aboveleft split'

    autocmd vimrc FileType vimfiler call s:vimfiler_settings()
    function! s:vimfiler_settings() "{{{
        nmap <buffer> L <Plug>(vimfiler_move_to_history_forward)
        nmap <buffer> H <Plug>(vimfiler_move_to_history_back)
        nmap <buffer> <C-o> <Plug>(vimfiler_move_to_history_back)
        nmap <buffer> <C-i> <Plug>(vimfiler_move_to_history_forward)

        nunmap <buffer> N
        nunmap <buffer> j
        nunmap <buffer> k
        nunmap <buffer> ?

        " dd as <Plug>(vimfiler_force_delete_file)
        " because I want to use trash-put.
        nunmap <buffer> d
        nmap <buffer> dd <Plug>(vimfiler_force_delete_file)

        nmap <buffer> <Space><Space> <Plug>(vimfiler_toggle_mark_current_line)
    endfunction "}}}
endfunction
