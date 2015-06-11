
" <C-]> for gtags.
function! s:JumpTags() "{{{
    if expand('%') == '' | return | endif

    if !exists(':GtagsCursor')
        echo "gtags.vim is not installed. do default <C-]>..."
        sleep 2
        " unmap this function.
        " use plain <C-]> next time.
        Map! [n] <C-]>
        execute "normal! \<C-]>"
        return
    endif

    let gtags = expand('%:h') . '/GTAGS'
    if filereadable(gtags)
        " use gtags if found GTAGS.
        lcd %:p:h
        GtagsCursor
        lcd -
    else
        " or use ctags.
        execute "normal! \<C-]>"
    endif
endfunction "}}}

Map -unique [n] <C-]>     :<C-u>call <SID>JumpTags()<CR>
