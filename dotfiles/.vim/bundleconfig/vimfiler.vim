let s:config = vivacious#bundleconfig#new()

function! s:config.config()
    let g:vimfiler_as_default_explorer = 1
    let g:vimfiler_safe_mode_by_default = 0
    let g:vimfiler_split_command = 'aboveleft split'

    autocmd vimrc FileType vimfiler call s:vimfiler_settings()
    function! s:vimfiler_settings() "{{{
        Map -buffer -remap -force [n] L <Plug>(vimfiler_move_to_history_forward)
        Map -buffer -remap -force [n] H <Plug>(vimfiler_move_to_history_back)
        Map -buffer -remap -force [n] <C-o> <Plug>(vimfiler_move_to_history_back)
        Map -buffer -remap -force [n] <C-i> <Plug>(vimfiler_move_to_history_forward)

        " TODO
        " Map! -buffer [n] N j k
        Map! -buffer [n] N
        Map! -buffer [n] j
        Map! -buffer [n] k
        Map! -buffer [n] ?

        " dd as <Plug>(vimfiler_force_delete_file)
        " because I want to use trash-put.
        Map! -buffer [n] d
        Map -remap -buffer -force [n] dd <Plug>(vimfiler_force_delete_file)

        Map -remap -buffer -force [n] <Space><Space> <Plug>(vimfiler_toggle_mark_current_line)
    endfunction "}}}
endfunction
