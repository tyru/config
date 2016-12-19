let s:config = vivo#plugconf#new()

function! s:config.config()
    MapAlterCommand gr[ep] OMGrep
    MapAlterCommand re[place] OMReplace

    nmap <Space>gw <Plug>(omg-grep-cword-word)
    nmap <Space>gW <Plug>(omg-grep-cWORD-word)
    nmap <C-g> <Plug>(omg-grep-cword-word)
    vmap <C-g> <Plug>(omg-grep-selected)
endfunction
