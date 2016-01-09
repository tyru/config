let s:config = vivacious#bundleconfig#new()

function! s:config.config()
    MapAlterCommand gr[ep] OMGrep
    MapAlterCommand re[place] OMReplace

    Map -remap [n] <Space>gw <Plug>(omg-grep-cword-word)
    Map -remap [n] <Space>gW <Plug>(omg-grep-cWORD-word)
    Map -remap [n] <C-g> <Plug>(omg-grep-cword-word)
    Map -remap [v] <C-g> <Plug>(omg-grep-selected)
endfunction
