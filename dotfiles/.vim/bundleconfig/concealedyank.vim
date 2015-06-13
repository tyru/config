let s:config = BundleConfigGet()

function! s:config.config()
    Map -remap [x] <operator>cy <Plug>(operator-concealedyank)
    " concealedyank.vim does not support operator yet.
    " Map -remap [no] y <Plug>(operator-concealedyank)
endfunction
