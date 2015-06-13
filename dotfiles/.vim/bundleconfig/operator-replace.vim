let s:config = BundleConfigGet()

function! s:config.config()
    Map -remap [nxo] <operator>p  <Plug>(operator-replace)
    " Map -remap [xo] p <Plug>(operator-replace)
endfunction
